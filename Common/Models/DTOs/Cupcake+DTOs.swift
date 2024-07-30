//
//  Cupcake.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import CoreData
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
    struct Get: Codable, Sendable, Identifiable, Equatable, Hashable {
        let id: UUID
        let coverImage: Data
        let flavor: String
        let ingredients: [String]
        let price: Double
        let createdAt: Date
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(UUID.self, forKey: .id)
            self.coverImage = try container.decode(Data.self, forKey: .coverImage)
            self.flavor = try container.decode(String.self, forKey: .flavor)
            self.ingredients = try container.decode([String].self, forKey: .ingredients)
            self.price = try container.decode(Double.self, forKey: .price)
            self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        }
    }
}
