//
//  Token.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

/// A representation of a Token.
struct Token: Codable, Sendable {
    let id: UUID
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "token"
    }
    
    init(from decoder: any Decoder) throws {
        self.id = .init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(String.self, forKey: .value)
    }
}
