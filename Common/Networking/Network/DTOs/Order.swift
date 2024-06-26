//
//  Order.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 23/04/24.
//

import Foundation

struct Order { }

extension Order {
    struct Get: Codable, Identifiable, Equatable {
        let id: UUID
        let userName: String
        let cupcake: Cupcake.Get
        let quantity: Int
        let extraFrosting: Bool
        let addSprinkles: Bool
        let finalPrice: Double
        let status: Status
        let orderTime: Date
        let outForDelivery: Date?
        let deliveredTime: Date?
        
        static func == (lhs: Get, rhs: Get) -> Bool {
            lhs.id == rhs.id
        }
        
        private init (
            id: UUID,
            userName: String,
            cupcake: Cupcake.Get,
            quantity: Int,
            extraFrosting: Bool,
            addSprinkles: Bool,
            finalPrice: Double,
            status: Status,
            orderTime: Date,
            outForDelivery: Date?,
            deliveredTime: Date?
        ) {
            self.id = id
            self.userName = userName
            self.cupcake = cupcake
            self.quantity = quantity
            self.extraFrosting = extraFrosting
            self.addSprinkles = addSprinkles
            self.finalPrice = finalPrice
            self.status = status
            self.orderTime = orderTime
            self.outForDelivery = outForDelivery
            self.deliveredTime = deliveredTime
        }
    }
}

extension Order {
    struct Create: Encodable {
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

extension Order {
    struct Update: Codable {
        var id: UUID
        var status: Status
    }
}
