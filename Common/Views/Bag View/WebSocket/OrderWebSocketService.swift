//
//  OrderWebSocketService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//

import Combine
import Foundation
import WebSocketHandler

extension BagView {
    final class OrderWebSocketService: @unchecked Sendable {
        private var webSocketService: WebSocketService<WebSocketMessage<Receive>>
        
        private var receiveValuetask: Task<Void, Never>?
        private var startConnectionTask: Task<Void, Never>?
        private var pingTask: Task<Void, Never>?
        private var isSendingPingValid: Bool
        let orderReceivedSubject: PassthroughSubject<Receive, WebSocketConnectionError>
        
        func startConnection() {
            startConnectionTask = Task {
                do {
                    try await webSocketService.start()
                } catch {
                    try? await disconnect(with: .failure(.noConnection), isChannelDisconnected: true)
                }
            }
        }
        
        private func receiveValuesObserver() {
            receiveValuetask = Task {
                do {
                    for try await orderReceived in webSocketService.messageReceivedSubject.values {
                        let message = orderReceived.data
                        orderReceivedSubject.send(message)
                    }
                } catch {
                    try? await disconnect(
                        with: .failure(.receiveDataFailed),
                        isChannelDisconnected: true
                    )
                }
            }
        }
        
        private func sendPing() {
            pingTask = Task {
                do {
                    try await Task.sleep(for: .seconds(15))
                    
                    guard isSendingPingValid else {
                        throw WebSocketConnectionError.noConnection
                    }
                    
                    try await webSocketService.sendPing()
                    sendPing()
                } catch {
                    try? await disconnect(with: .failure(.noConnection))
                }
            }
        }
        
        func disconnect(
            with finishType: Subscribers.Completion<WebSocketConnectionError> = .finished,
            isChannelDisconnected: Bool = false
        ) async throws {
            if !isChannelDisconnected {
                let disconnectMessage = WebSocketMessage<Send>(data: .disconnect)
                try await send(disconnectMessage)
            }
            
            try await webSocketService.disconnect()
            orderReceivedSubject.send(completion: finishType)
            receiveValuetask?.cancel()
            receiveValuetask = nil
            pingTask?.cancel()
            pingTask = nil
            isSendingPingValid = false
            startConnectionTask?.cancel()
            startConnectionTask = nil
        }
        
        func send(_ message: WebSocketMessage<Send>) async throws {
            let encoder = JSONEncoder()
            guard let messageData = try? encoder.encode(message) else {
                throw WebSocketConnectionError.encodingError
            }
            
            try await webSocketService.send(messageData)
        }
        
        init(with authorizationValue: String) {
            webSocketService = .init(
                host: "127.0.0.1",
                port: 8080,
                uri: "/order/channel",
                authorizationValue: authorizationValue
            )
            
            orderReceivedSubject = .init()
            isSendingPingValid = true
            receiveValuesObserver()
            sendPing()
            startConnection()
        }
        
        deinit {
            print("OrderWebSocketService was deinitialized.")
        }
    }
}
