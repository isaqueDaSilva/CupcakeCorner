//
//  Cupcake.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation
import SwiftUI

extension Cupcake {
    /// A representation of the all keys utilized for encoding or decoding a cupcake's data.
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case coverImage = "cover_image"
        case flavor = "flavor"
        case ingredients = "ingredients"
        case price = "price"
        case createdAt = "created_at"
    }
}

extension Cupcake {
    /// A cupcake's data representation for decoding data that coming from the API request when is finished.
    struct Get: Codable, Identifiable, Equatable, Hashable, Sendable {
        let id: UUID
        var coverImage: Data
        var flavor: String
        var ingredients: [String]
        var price: Double
        let createdAt: Date
        
        private init(
            id: UUID,
            coverImage: Data,
            flavor: String,
            ingredients: [String],
            price: Double,
            createAt: Date = .now
        ) {
            self.id = id
            self.coverImage = coverImage
            self.flavor = flavor
            self.ingredients = ingredients
            self.price = price
            self.createdAt = createAt
        }
    }
}
