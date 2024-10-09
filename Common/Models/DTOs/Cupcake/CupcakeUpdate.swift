//
//  Cupcake+Update.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//


import Foundation

extension Cupcake {
    /// A representation of the data that used for update a cupcake.
    struct Update: Encodable, Sendable {
        var flavor: String?
        var coverImage: Data?
        var ingredients: [String]?
        var price: Double?
        
        mutating func set(
            coverImage: Data? = nil,
            flavor: String? = nil,
            ingredients: [String]? = nil,
            price: Double? = nil
        ) -> Self {
            if let coverImage {
                self.coverImage = coverImage
            }
            
            if let flavor {
                self.flavor = flavor
            }
            
            if let ingredients {
                self.ingredients = ingredients
            }
            
            if let price {
                self.price = price
            }
            
            return self
        }
        
        init(
            coverImage: Data? = nil,
            flavor: String? = nil,
            ingredients: [String]? = nil,
            price: Double? = nil
        ) {
            self.flavor = flavor
            self.coverImage = coverImage
            self.ingredients = ingredients
            self.price = price
        }
    }
}
