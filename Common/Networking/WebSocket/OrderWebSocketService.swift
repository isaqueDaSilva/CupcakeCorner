//
//  OrderWebSocketService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 08/05/24.
//

import Combine
import Foundation

final class OrderWebSocketService: NSObject {
    
    private var webSocketTask: URLSessionWebSocketTask?
    let orderReceivedSubject: PassthroughSubject<WebSocketMessage<Receive>, WebSocketConnectionError>
    private var receiveTask: Task<Void, Never>?
    
    func connect() throws {
        let endpoint = "ws://127.0.0.1:8080/api/order/channel"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.badURL
        }
        
        let tokenValue = try KeychainService.retrive()
        let bearerValue = AuthorizationHeader.bearer.rawValue
        
        var request = URLRequest(url: url)
        request.setValue(
            "\(bearerValue) \(tokenValue)",
            forHTTPHeaderField: HTTPHeaderField.authorization.rawValue
        )
        
        // Configures the URLSession with default configuration,
        // and invokes the OperationQueue object
        // with default initialize to read the current queue and operate on it.
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveData()
    }
    
    private func sendPing() {
        let taskIdentifier = webSocketTask?.taskIdentifier ?? -1
        
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self else { return }
            
            guard let task = self.webSocketTask, task.taskIdentifier == taskIdentifier else { return }
            
            if task.state == .running {
                task.sendPing {  error in
                    if let error {
                        print("Falied to receive pong with \(error)")
                    } else {
                        print("Connection is alive")
                    }
                    
                    self.sendPing()
                }
            } else {
                reconnect()
            }
        }
    }
    
    private func receiveData() {
        receiveTask = Task {
            do {
                guard let messages = try await webSocketTask?.receive() else { return }
                
                switch messages {
                case .data(let data):
                    self.onReceive(data)
                case .string(let reason):
                    self.disconnect(
                        with: .unsupportedData,
                        reason: reason
                    )
                @unknown default:
                    self.disconnect(
                        with: .internalServerError,
                        reason: "Closing with an unexpected error occur."
                    )
                }
                
                receiveData()
            } catch let error {
                disconnect(
                    with: .unsupportedData,
                    reason: error.localizedDescription,
                    and: .unknownError(error)
                )
            }
        }
    }
    
    private func onReceive(_ data: Data) {
        guard let receivedOrder = try? data.decodeWebSocketMessage(Receive.self) else {
            orderReceivedSubject.send(completion: .failure(WebSocketConnectionError.decodingError))
            return
        }
        
        orderReceivedSubject.send(receivedOrder)
    }
    
    func send(_ message: WebSocketMessage<Send>) async throws {
        guard let messageData = try? message.encodeWebSocketMessage() else {
            throw WebSocketConnectionError.encodingError
        }
        
        try await webSocketTask?.send(.data(messageData))
    }
    
    func disconnect(
        with closeCode: URLSessionWebSocketTask.CloseCode = .normalClosure,
        reason: String = "Closing connection",
        and error: WebSocketConnectionError? = nil
    ) {
        let reason = reason.data(using: .utf8)
        
        receiveTask?.cancel()
        receiveTask = nil
        
        webSocketTask?.cancel(with: closeCode, reason: reason)
        webSocketTask = nil
        orderReceivedSubject.send(completion: (error != nil) ? .failure(error ?? .noConnection) : .finished)
    }
    
    private func reconnect() {
        do {
            disconnect()
            try connect()
        } catch {
            print("Falied to reconnect the server with \(error.localizedDescription)")
        }
    }
    
    override init() {
        self.webSocketTask = nil
        self.orderReceivedSubject = .init()
        self.receiveTask = nil
        
        super.init()
    }
    
    deinit {
        disconnect()
    }
}

extension OrderWebSocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        receiveData()
        sendPing()
        print("Web Socket did connect")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
}
