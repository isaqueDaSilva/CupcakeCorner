//
//  Cupcake.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/06/24.
//
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Cupcake {
    @Attribute(.unique)
    let id: UUID
    
    @Attribute(.unique)
    var flavor: String
    var ingredients: [String]
    var price: Double
    
    @Attribute(.externalStorage)
    var coverImage: Data
    
    let createAt: Date
    
    private init(
        id: UUID,
        flavor: String,
        ingredients: [String],
        price: Double,
        coverImage: Data,
        createAt: Date
    ) {
        self.id = id
        self.flavor = flavor
        self.ingredients = ingredients
        self.price = price
        self.coverImage = coverImage
        self.createAt = createAt
    }
    
    convenience init(from result: Get) {
        self.init(
            id: result.id,
            flavor: result.flavor,
            ingredients: result.ingredients,
            price: result.price,
            coverImage: result.coverImage,
            createAt: result.createdAt
        )
    }
}

extension Cupcake {
    @MainActor
    static let sampleCupcakes: [Cupcake] = {
        var cupcakes = [Cupcake]()
        
        for index in 0..<10 {
            let image = UIImage(systemName: Icon.shippingBox.rawValue)
            let imageData = image?.pngData()
            
            if let imageData {
                let cupcake = Cupcake(
                    id: .init(),
                    flavor: "Cupcake \(index + 1)",
                    ingredients: ["Ingredient 1", "Ingredient 2", "Ingredient 3"],
                    price: Double(index + 1),
                    coverImage: imageData,
                    createAt: .now
                )
            }
        }
        
        return cupcakes
    }()
}

extension Cupcake {
    var image: UIImage? { .init(data: self.coverImage) }
}
