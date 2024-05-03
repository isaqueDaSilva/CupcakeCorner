//
//  Cupcake.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation
import SwiftData

@Model
final class Cupcake: Identifiable {
    let id: UUID
    var coverImage: Data
    var flavor: String
    var ingredients: [String]
    var price: Double
    let createdAt: Date
    
    init(
        id: UUID,
        coverImage: Data,
        flavor: String,
        ingredients: [String],
        price: Double,
        createdAt: Date
    ) {
        self.id = id
        self.coverImage = coverImage
        self.flavor = flavor
        self.ingredients = ingredients
        self.price = price
        self.createdAt = createdAt
    }
    
    convenience init(for result: CupcakeResults) {
        self.init(
            id: result.id,
            coverImage: result.coverImage,
            flavor: result.flavor,
            ingredients: result.ingredients,
            price: result.price,
            createdAt: result.createdAt
        )
    }
}
