//
//  Order.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/06/24.
//
//

import Foundation
import SwiftData

@Model
final class Order {
    @Attribute(.unique)
    let id: UUID
    let userName: String
    let cupcake: Cupcake
    let quantity: Int
    let addSprinkles: Bool
    let extraFrosting: Bool
    let finalPrice: Double
    var status: Status
    let orderTime: Date
    var outForDelivery: Date?
    var deliveredTime: Date?
    
    private init(
        id: UUID,
        userName: String,
        cupcake: Cupcake,
        quantity: Int,
        addSprinkles: Bool,
        extraFrosting: Bool,
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
        self.addSprinkles = addSprinkles
        self.extraFrosting = extraFrosting
        self.finalPrice = finalPrice
        self.status = status
        self.orderTime = orderTime
        self.outForDelivery = outForDelivery
        self.deliveredTime = deliveredTime
    }
    
    convenience init(from result: Get, and cupcake: Cupcake) {
        self.init(
            id: result.id,
            userName: result.userName,
            cupcake: cupcake,
            quantity: result.quantity,
            addSprinkles: result.addSprinkles,
            extraFrosting: result.extraFrosting,
            finalPrice: result.finalPrice,
            status: result.status,
            orderTime: result.orderTime,
            outForDelivery: result.outForDelivery,
            deliveredTime: result.deliveredTime
        )
    }
}

extension Order {
    @MainActor
    static let sampleOrder: [Order] = {
        var orders = [Order]()
        
        for index in 0..<10 {
            let cupcakes = Cupcake.sampleCupcakes
            
            let order = Order(
                id: .init(),
                userName: "Client \(index + 1)",
                cupcake: cupcakes.randomElement() ?? cupcakes[0],
                quantity: index + 1,
                addSprinkles: .random(),
                extraFrosting: .random(),
                finalPrice: .random(in: 5...100),
                status: .ordered,
                orderTime: .now,
                outForDelivery: nil,
                deliveredTime: nil
            )
        }
        
        return orders
    }()
}
