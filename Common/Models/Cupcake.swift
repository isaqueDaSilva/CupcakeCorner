//
//  Cupcake.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Cupcake {
    #Unique<Cupcake>([\.id, \.flavor])
    #Index<Cupcake>([\.id])
    
    var id: UUID
    var flavor: String
    var ingredients: [String]
    var price: Double

    @Attribute(.externalStorage)
    var coverImage: Data
    var createAt: Date
    
    var orders: [Order]?
    
    var ordersWrapped: [Order] {
        guard let orders else { return [] }
        return orders
    }
    
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
        self.orders = []
    }
}

extension Cupcake: DataModel {
    typealias Result = Get
    
    static func create(from result: Get) -> Self {
        self.init(
            id: result.id,
            flavor: result.flavor,
            ingredients: result.ingredients,
            price: result.price,
            coverImage: result.coverImage,
            createAt: result.createAt
        )
    }
}

extension Cupcake {
    func update(from result: Get) -> Self {
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
            coverImage = result.coverImage
        }
        
        return self
    }
}

// MARK: - Sample -
extension Cupcake {
    static func makeSampleCupcakes(in context: ModelContext) throws {
        #if canImport(UIKit)
        let image = UIImage(systemName: Icon.shippingBox.rawValue)
        let imageData = image?.pngData()
        #elseif canImport(AppKit)
        let image = NSImage(systemSymbolName: Icon.shippingBox.rawValue, accessibilityDescription: nil)
        let imageData = image?.tiffRepresentation
        #endif
        
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
            
            context.insert(newCupcake)
        }
        
        try context.save()
    }
}
