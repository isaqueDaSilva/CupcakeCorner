//
//  OrderWebSocketService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 08/05/24.
//

import Combine
import Foundation

/// An object for manager the Web Socket task.
final class OrderWebSocketService: NSObject {
    
    /// The current value for the current URLSessionWebSocketTask
    private var webSocketTask: URLSessionWebSocketTask?
    
    /// The subject for handle with the current values received from the web socket task.
    let orderReceivedSubject: PassthroughSubject<WebSocketMessage<Receive>, WebSocketConnectionError>
    
    /// The current value for the Task instance indicating that the task is alive or not.
    private var receiveTask: Task<Void, Never>?
    
    /// Conects on WebSocket channel on backend service.
    func connect() throws {
        
        // Gets the endpoint string and checks
        // if it's valid, if no valid, a "bad url" error
        // will be launched.
        let endpoint = "ws://127.0.0.1:8080/api/order/channel"
        guard let url = URL(string: endpoint) else {
            throw APIError.badURL
        }
        
        // Gets the token value and the bearer value
        // for passing in the HTTP header field.
        let tokenValue = try KeychainService.retrive()
        let bearerValue = AuthorizationHeader.bearer.rawValue
        
        // Creates a new URLRequest instance
        // and set with the token and bearer values.
        var request = URLRequest(url: url)
        request.setValue(
            "\(bearerValue) \(tokenValue)",
            forHTTPHeaderField: HTTPHeaderField.authorization.rawValue
        )
        
        // Configures URLSession instance with default configuration,
        // and references this class as the your delegate.
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        
        // Makes a connection with the WebSocket channel
        // creating a new URLSessionWebSocketTask instance
        // and calling the receiveData method for monitoring
        // the data received from the channel
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveData()
    }
    
    /// Scheduling the send ping for the WebSocket channel.
    private func sendPing() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self else { return }
            
            // Checking if the webSocketTask is not equal to nil.
            guard let task = self.webSocketTask else { return }
            
            // Checking if the task is running
            if task.state == .running {
                // If the task is running,
                // a ping is sending.
                task.sendPing {  error in
                    if let error {
                        print("Falied to receive pong with \(error)")
                    } else {
                        print("Connection is alive")
                    }
                    
                    // Calls again the method for makes a loop
                    // until the task is cancelled.
                    self.sendPing()
                }
            } else {
                // If the task is not runnig
                // will calling the reconnect method.
                reconnect()
            }
        }
    }
    
    /// Observes if some data is received on the current channel of WebSocket.
    private func receiveData() {
        receiveTask = Task {
            do {
                // Calls the receive method from the URLSessionWebSocketTask.
                guard let messages = try await webSocketTask?.receive() else { return }
                
                // Cheks what type data
                // was received.
                switch messages {
                case .data(let data):
                    // Calls the onReveive
                    // method for decoding
                    // and send the data for the
                    // publisher.
                    self.onReceive(data)
                case .string(let reason):
                    // Calls the disconnect method
                    // if the type received is a String.
                    
                    self.disconnect(
                        with: .unsupportedData,
                        reason: reason
                    )
                @unknown default:
                    // Calls the disconnect method
                    // if the type received is unknown.
                    
                    self.disconnect(
                        with: .internalServerError,
                        reason: "Closing with an unexpected error occur."
                    )
                }
                
                // Calls again the method for makes a loop
                // until the task is cancelled.
                receiveData()
            } catch let error {
                // Calls the disconnect method
                // if some error occur..
                disconnect(
                    with: .unsupportedData,
                    reason: error.localizedDescription,
                    and: .unknownError(error)
                )
            }
        }
    }
    
    /// Handles with data received from the WebSocket channel.
    private func onReceive(_ data: Data) {
        // Decodes the data type into a Receive order type message.
        guard let receivedOrder = try? data.decodeWebSocketMessage(Receive.self) else {
            orderReceivedSubject.send(completion: .failure(WebSocketConnectionError.decodingError))
            return
        }
        
        // Sending a received order for the subject.
        orderReceivedSubject.send(receivedOrder)
    }
    
    /// Sending a message for the WebSocket channel.
    /// - Parameter message: The type of message to be sent.
    func send(_ message: WebSocketMessage<Send>) async throws {
        // Encodes the message type into a data type.
        guard let messageData = try? message.encodeWebSocketMessage() else {
            throw WebSocketConnectionError.encodingError
        }
        
        // Calls the send method from the URLSessionWebSocketTask
        // and send the message for the channel.
        try await webSocketTask?.send(.data(messageData))
    }
    
    /// Disconnecting from the WebSocket channel.
    /// - Parameters:
    ///   - closeCode: Why the channel was closed.
    ///   - reason: The reason why the channel is closed.
    ///   - error: The type of the error was occur.
    func disconnect(
        with closeCode: URLSessionWebSocketTask.CloseCode = .normalClosure,
        reason: String = "Closing connection",
        and error: WebSocketConnectionError? = nil
    ) {
        let reason = reason.data(using: .utf8)
        
        // Cancelling the Task.
        receiveTask?.cancel()
        receiveTask = nil
        
        // Cancelling the URLSessionWebSocketTask and send
        // a completation for the publisher inform
        // that your work is finished or finished with error.
        webSocketTask?.cancel(with: closeCode, reason: reason)
        webSocketTask = nil
        orderReceivedSubject.send(completion: (error != nil) ? .failure(error ?? .noConnection) : .finished)
    }
    
    /// Reconnecting in the channel.
    private func reconnect() {
        do {
            // Disconnecting the channel
            disconnect()
            
            // Trying to make a new connection
            // in the channel.
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
        
        print("Initialized with success.")
    }
    
    deinit {
        disconnect()
        print("Deinitialization finished with success")
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
