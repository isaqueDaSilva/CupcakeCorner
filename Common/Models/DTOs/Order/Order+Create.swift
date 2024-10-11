//
//  Order+Create.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

extension Order {
    /// A representation of the data that used for create an order.
    struct Create: Encodable, Sendable {
        let cupcakeID: UUID
        let quantity: Int
        let extraFrosting: Bool
        let addSprinkles: Bool
        let finalPrice: Double
    }
}
