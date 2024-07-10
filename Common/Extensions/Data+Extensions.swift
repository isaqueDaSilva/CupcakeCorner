//
//  Data+Extensions.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 03/06/24.
//

import Foundation
import SwiftUI

extension Data {
    /// Decodes the data in a matched model that have a conformance with the Decodable protocol.
    func decode<M: Decodable>(_ model: M.Type) throws -> M {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let model = try decoder.decode(model, from: self)
        
        return model
    }
    
    /// Loads an UIImage from `Data` type.
    func loadImage() -> UIImage? { UIImage(data: self) }
    
    /// Decodes a message type from data coming from the Web Socket server.
    /// - Parameter model: A representation of the type of the data model.
    /// - Returns: Returns a message based on data taht came from the server.
    func decodeWebSocketMessage<T: Decodable>(_ model: T.Type) throws -> BagView.WebSocketMessage<T> {
        let message = try JSONDecoder().decode(BagView.WebSocketMessage<T>.self, from: self)
        
        return message
    }
}
