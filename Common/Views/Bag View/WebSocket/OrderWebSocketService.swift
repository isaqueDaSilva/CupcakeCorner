//
//  OrderWebSocketService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 08/05/24.
//

import Combine
import Foundation
import WebSocketHandler

extension BagView {
    final class OrderWebSocketService: @unchecked Sendable {
        private var webSocketService: WebSocketService<WebSocketMessage<Receive>>
        
        private var receiveValuetask: Task<Void, Never>?
        private var isSendingPingValid: Bool
        let orderReceivedSubject: PassthroughSubject<Receive, WebSocketConnectionError>
        
        
        func startConnection(with clientID: UUID) async throws {
            do {
                let initialMessage = WebSocketMessage<Send>(for: clientID, with: .get)
                try await webSocketService.start(with: initialMessage)
            } catch {
                orderReceivedSubject.send(completion: .failure(.noConnection))
                throw error
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
                    isSendingPingValid = false
                    orderReceivedSubject.send(completion: .failure(.receiveDataFailed))
                    receiveValuetask?.cancel()
                    receiveValuetask = nil
                }
            }
        }
        
        func sendPing() async throws {
            
            guard isSendingPingValid else {
                throw WebSocketConnectionError.noConnection
            }
            
            try await webSocketService.sendPing()
        }
        
        func disconnect() async throws {
            try await webSocketService.disconnect()
            orderReceivedSubject.send(completion: .finished)
            receiveValuetask?.cancel()
            receiveValuetask = nil
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
                uri: "/api/order/channel",
                authorizationValue: authorizationValue
            )
            
            orderReceivedSubject = .init()
            isSendingPingValid = true
            receiveValuesObserver()
        }
        
        deinit {
            print("OrderWebSocketService was deinitialized.")
        }
    }
}
