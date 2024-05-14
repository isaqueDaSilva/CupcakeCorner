//
//  OrderWebSocketService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 08/05/24.
//

import Combine
import Foundation

final class OrderWebSocketService: NSObject {
    private let session: URLSession
    private var webSocketTask: URLSessionWebSocketTask?
    
    private let orderListSubject: CurrentValueSubject<[Order], Never>
    private var orderList: [Order] { orderListSubject.value }
    
    private let connectionStatusSubject: CurrentValueSubject<Bool, Never>
    private var isConnected: Bool { connectionStatusSubject.value }
    
    func connect() throws {
        let endpoint = "ws://127.0.0.1:8080/api/order/channel"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.badURL
        }
        
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.delegate = self
        webSocketTask?.resume()
    }
    
    override init() {
        self.session = URLSession(configuration: .default)
        self.webSocketTask = nil
        self.orderListSubject = .init([])
        self.connectionStatusSubject = .init(false)
        
        super.init()
    }
    
    deinit {
        orderListSubject.send(completion: .finished)
        connectionStatusSubject.send(completion: .finished)
    }
}

extension OrderWebSocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
    }
}
