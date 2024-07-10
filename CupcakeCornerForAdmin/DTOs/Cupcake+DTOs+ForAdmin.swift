//
//  Cupcake+DTOs.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 24/06/24.
//

import Foundation

extension Cupcake {
    /// A representation of the data that used for create a cupcake.
    struct Create: Encodable, Sendable {
        var coverImage: Data
        var flavor: String
        var ingredients: [String]
        var price: Double
    }
}

extension Cupcake {
    /// A representation of the data that used for update a cupcake.
    struct Update: Encodable, Sendable {
        let coverImage: Data?
        let flavor: String?
        let ingredients: [String]?
        let price: Double?
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.coverImage, forKey: CodingKeys.coverImage)
            try container.encodeIfPresent(self.flavor, forKey: CodingKeys.flavor)
            try container.encodeIfPresent(self.ingredients, forKey: CodingKeys.ingredients)
            try container.encodeIfPresent(self.price, forKey: CodingKeys.price)
        }
    }
}
