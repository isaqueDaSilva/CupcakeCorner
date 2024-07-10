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
        
        private var task: Task<Void, Never>?
        let orderReceivedSubject: PassthroughSubject<Receive, WebSocketConnectionError>
        
        func startConnection(with clientID: UUID) async throws {
            let initialMessage = WebSocketMessage<Send>(for: clientID, with: .get)
            try await webSocketService.start(with: initialMessage)
        }
        
        private func receiveValuesObserver() {
            task = Task {
                do {
                    for try await orderReceived in webSocketService.messageReceivedSubject.values {
                        let message = orderReceived.data
                        orderReceivedSubject.send(message)
                    }
                } catch {
                    orderReceivedSubject.send(completion: .failure(.receiveDataFailed))
                    task = nil
                }
            }
        }
        
        func sendPing() async throws {
            try await webSocketService.sendPing()
        }
        
        func disconnect() async throws {
            try await webSocketService.disconnect()
            orderReceivedSubject.send(completion: .failure(.disconected))
            task = nil
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
            receiveValuesObserver()
        }
    }
}
