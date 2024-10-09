//
//  Data+Extension.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/30/24.
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
}
