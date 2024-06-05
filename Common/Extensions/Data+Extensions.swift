//
//  Data+Extensions.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 03/06/24.
//

import Foundation

extension Data {
    func decode<M: Decodable>(_ model: M.Type) throws -> M {
        let model = try JSONDecoder().decode(model, from: self)
        
        return model
    }
}
