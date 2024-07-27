//
//  Cupcake.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 08/07/24.
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
    
    var orders: [Order] = []
    
    var image: Image { .init(by: coverImage) }
    
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
}

// Create new cupcake from Result.
extension Cupcake {
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

// Checks if Result is equal to the saved object
extension Cupcake {
    func isEqual(to result: Get) -> Bool {
        (flavor == result.flavor) &&
        (ingredients == result.ingredients) &&
        (price == result.price) &&
        (coverImage == result.coverImage)
    }
}

// Updates a Cupcake from Result
extension Cupcake {
    func update(from result: Get) {
        if result.flavor != flavor {
            flavor = result.flavor
        }
        
        if result.ingredients != ingredients {
            ingredients = result.ingredients
        }
        
        if result.price != price {
            price = result.price
        }
        
        if result.coverImage != coverImage {
            coverImage = coverImage
        }
    }
}

// Creates samples cupcakes for uses in preview.
extension Cupcake {
    static var sampleCupcakes: [Cupcake] {
        var cupcakes = [Cupcake]()
        
        let image = UIImage(systemName: Icon.shippingBox.rawValue)
        let imageData = image?.pngData()
        
        for index in 0..<10 {
            guard let imageData else { break }
            
            let newCupcake = Cupcake(
                id: .init(),
                flavor: "Flavor \(index + 1)",
                ingredients: ["Ingredient \(index + 1)"],
                price: .random(in: 3...10),
                coverImage: imageData,
                createAt: .now
            )
            
            cupcakes.append(newCupcake)
        }
        
        return cupcakes
    }
}
