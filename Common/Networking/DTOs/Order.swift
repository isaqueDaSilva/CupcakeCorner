//
//  Order.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 23/04/24.
//

import Foundation

extension Order {
    /// An  order representation for decoding data that coming from the API request when is finished.
    struct Get: Codable, Identifiable, Sendable {
        let id: UUID
        let userName: String
        let cupcake: UUID
        let quantity: Int
        let extraFrosting: Bool
        let addSprinkles: Bool
        let finalPrice: Double
        let status: Status
        let orderTime: Date
        let outForDelivery: Date?
        let deliveredTime: Date?
    }
}
