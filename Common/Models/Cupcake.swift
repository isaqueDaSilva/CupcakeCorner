//
//  Cupcake.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation
import SwiftUI

extension Cupcake {
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
    struct Get: Codable, Identifiable, Equatable, Hashable {
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

extension Cupcake {
    struct Create: Encodable {
        var coverImage: Data
        var flavor: String
        var ingredients: [String]
        var price: Double
    }
}

extension Cupcake {
    struct Update: Encodable {
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

extension Cupcake.Get {
    static var sampleCupcakes: [Cupcake.Get] {
        let image = UIImage(systemName: Icon.bag.rawValue)
        let imageData = image?.pngData()
        
        return [
            .init(id: UUID(), coverImage: imageData!, flavor: "Chocolate", ingredients: ["Chocolate", "Mental"], price: 3.0),
            .init(id: UUID(), coverImage: imageData!, flavor: "Vanila", ingredients: ["Vanila", "Milk"], price: 3.5)
        ]
    }
}
