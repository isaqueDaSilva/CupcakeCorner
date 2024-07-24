//
//  CupcakeUpdater.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 16/06/24.
//

import Foundation
import SwiftUI

extension UpdateCupcakeView {
    enum CupcakeUpdater {
        static func update(
            _ cupcake: Cupcake,
            with imageData: Data?,
            _ flavor: String,
            _ ingredients: [String],
            and price: Double
        ) -> Cupcake.Update {
            var updatedCupcake = Cupcake.Update()
            
            if imageData != cupcake.coverImage {
                updatedCupcake = Cupcake.Update(coverImage: imageData)
            }
            
            if flavor != cupcake.flavor {
                updatedCupcake = Cupcake.Update(coverImage: imageData, flavor: flavor)
            }
            
            if ingredients != cupcake.ingredients {
                updatedCupcake = Cupcake.Update(coverImage: imageData, flavor: flavor, ingredients: ingredients)
            }
            
            if price != cupcake.price {
                updatedCupcake = Cupcake.Update(coverImage: imageData, flavor: flavor, ingredients: ingredients, price: price)
            }
            
            return updatedCupcake
        }
    }
}
