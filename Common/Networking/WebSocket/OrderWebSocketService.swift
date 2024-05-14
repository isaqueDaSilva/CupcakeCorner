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
    
    let orderReceivedSubject: PassthroughSubject<WebSocketMessage<Receive>, Error>
    
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
    
    private func receiveData() {
        webSocketTask?.receive { [weak self] results in
            guard let self else { return }
            
            switch results {
            case .success(let success):
                switch success {
                case .data(let data):
                    self.onReceive(data)
                case .string(let reason):
                    self.disconnect(
                        with: .unsupportedData,
                        and: reason
                    )
                @unknown default:
                    self.disconnect(
                        with: .internalServerError,
                        and: "Closing with an unexpected error occur."
                    )
                }
            case .failure(let failure):
                orderReceivedSubject.send(completion: .failure(WebSocketConnectionError.unknownError(failure)))
            }
            
            receiveData()
        }
    }
    
    private func onReceive(_ data: Data) {
        guard let receivedOrder = try? data.decodeWebSocketMessage(Receive.self) else {
            orderReceivedSubject.send(completion: .failure(WebSocketConnectionError.decodingError))
            return
        }
        
        orderReceivedSubject.send(receivedOrder)
    }
    
    func send(_ message: WebSocketMessage<Send>) throws {
        guard let messageData = try? message.encodeWebSocketMessage() else {
            throw WebSocketConnectionError.encodingError
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            self.webSocketTask?.send(.data(messageData)) { error in
                if let error {
                    print("Failed to send message with '\(error.localizedDescription)' error.")
                } else {
                    print("Success")
                }
            }
            
            self.receiveData()
        }
    }
    
    func disconnect(
        with closeCode: URLSessionWebSocketTask.CloseCode = .normalClosure,
        and reason: String = "Closing connection"
    ) {
        let reason = reason.data(using: .utf8)
        webSocketTask?.cancel(with: closeCode, reason: reason)
        webSocketTask = nil
        orderReceivedSubject.send(completion: .finished)
    }
    
    override init() {
        self.webSocketTask = nil
        self.orderReceivedSubject = .init()
        
        super.init()
    }
    
    deinit {
        orderReceivedSubject.send(completion: .finished)
    }
}

extension OrderWebSocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        receiveData()
        print("Web Socket did connect")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
}
