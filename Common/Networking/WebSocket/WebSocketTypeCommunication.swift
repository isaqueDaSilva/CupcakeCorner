//
//  WebSocketTypeCommunication.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/05/24.
//

import Foundation

/// A representation of the data of the message will be send to server.
struct WebSocketMessage<T: Codable>: Codable {
    let clientID: UUID
    let data: T
}

enum Send: Codable {
    /// Choose this case, if you want to send a request
    /// to the server to send requested data.
    case get
    
    /// Choice this case, if you want to send an updated data
    /// to the server.
    case update(Order.Update)
}

enum Receive: Codable {
    /// Choose this case if you want to receive the new order the moment a user places it.
    case newOrder(Order.Get)
    
    /// Choise this case, if you want to receive the all orders given from the server.
    case orders([Order.Get])
    
    /// Choice this case, if you want to receive an updated order coming from the server.
    case update(Order.Get)
}

extension Data {
    /// Decodes a message type from data coming from the Web Socket server.
    /// - Parameter model: A representation of the type of the data model.
    /// - Returns: Returns a message based on data taht came from the server.
    func decodeWebSocketMessage<T: Decodable>(_ model: T.Type) throws -> WebSocketMessage<T> {
        let message = try JSONDecoder().decode(WebSocketMessage<T>.self, from: self)
        
        return message
    }
}

extension WebSocketMessage {
    /// Encodes a message for send for the server.
    /// - Returns: Returns a data representation for send to the server
    func encodeWebSocketMessage() throws -> Data {
        let data = try JSONEncoder().encode(self)
        
        return data
    }
}
