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
            with coverImage: UIImage?,
            _ flavor: String,
            _ ingredients: [String],
            and price: Double
        ) -> Cupcake.Update {
            let imageData = coverImage?.pngData()
            
            let updatedCupcake = Cupcake.Update(
                coverImage: imageData,
                flavor: flavor,
                ingredients: ingredients,
                price: price
            )
            
            return updatedCupcake
        }
    }
}
