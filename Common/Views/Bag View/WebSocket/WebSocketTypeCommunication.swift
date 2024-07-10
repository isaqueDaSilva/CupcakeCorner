//
//  WebSocketTypeCommunication.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/05/24.
//

import Foundation

extension BagView {
    /// A representation of the data of the message will be send to server.
    struct WebSocketMessage<T: Codable & Sendable>: Codable, Sendable {
        let clientID: UUID
        let data: T
        
        /// Encodes a message for send for the server.
        /// - Returns: Returns a data representation for send to the server
        func encodeWebSocketMessage() throws -> Data {
            let data = try JSONEncoder().encode(self)
            
            return data
        }
        
        init(for clientID: UUID, with data: T) {
            self.clientID = clientID
            self.data = data
        }
    }
    
    enum Send: Codable, Sendable {
        /// Choose this case, if you want to send a request
        /// to the server to send requested data.
        case get
        
        #if ADMIN
        /// Choice this case, if you want to send an updated data
        /// to the server.
        case update(Order.Update)
        #endif
        
        case disconnect
    }
    
    enum Receive: Codable, Sendable {
        /// Choose this case if you want to receive the new order the moment a user places it.
        case newOrder(Order.Get)
        
        /// Choise this case, if you want to receive the all orders given from the server.
        case orders([Order.Get])
        
        /// Choice this case, if you want to receive an updated order coming from the server.
        case update(Order.Get)
    }
}
