//
//  Order+DTO.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 24/06/24.
//

import Foundation

extension Order {
    /// A representation of the data that used for create an order.
    struct Create: Encodable, Sendable {
        let cupcake: UUID?
        var quantity: Int
        var extraFrosting: Bool
        var addSprinkles: Bool
        var finalPrice: Double
        let status: Status = .ordered
        
        init(
            cupcake: UUID?,
            quantity: Int,
            extraFrosting: Bool,
            addSprinkles: Bool,
            finalPrice: Double
        ) {
            self.cupcake = cupcake
            self.quantity = quantity
            self.extraFrosting = extraFrosting
            self.addSprinkles = addSprinkles
            self.finalPrice = finalPrice
        }
    }
}
