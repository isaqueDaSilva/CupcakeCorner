//
//  WebSocketMessage.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//


import Foundation

extension BagView {
    /// A representation of the data of the message will be send to server.
    struct WebSocketMessage<T: Codable & Sendable>: Codable, Sendable {
        let data: T
    }
}

extension BagView {
    enum Send: Codable, Sendable {
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
        case allOrders([Order.Get])
        
        /// Choice this case, if you want to receive an updated order coming from the server.
        case update(Order.Get)
    }
}
