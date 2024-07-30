//
//  Order.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 08/07/24.
//

import Foundation
import SwiftData

@Model
final class Order {
    @Attribute(.unique)
    let id: UUID
    
    let userName: String
    let paymentMethod: PaymentMethod
    
    @Relationship(deleteRule: .nullify, inverse: \Cupcake.orders)
    var cupcake: Cupcake?
    let quantity: Int
    let addSprinkles: Bool
    let extraFrosting: Bool
    let finalPrice: Double
    var status: Status
    let orderTime: Date
    var readyForDeliveryTime: Date?
    var deliveredTime: Date?
    
    private init(
        id: UUID,
        userName: String,
        paymentMethod: PaymentMethod,
        cupcake: Cupcake,
        quantity: Int,
        addSprinkles: Bool,
        extraFrosting: Bool,
        finalPrice: Double,
        status: Status,
        orderTime: Date,
        readyForDeliveryTime: Date? = nil,
        deliveredTime: Date? = nil
    ) {
        self.id = id
        self.userName = userName
        self.paymentMethod = paymentMethod
        self.cupcake = cupcake
        self.quantity = quantity
        self.addSprinkles = addSprinkles
        self.extraFrosting = extraFrosting
        self.finalPrice = finalPrice
        self.status = status
        self.orderTime = orderTime
        self.readyForDeliveryTime = readyForDeliveryTime
        self.deliveredTime = deliveredTime
    }
}

extension Order {
    convenience init(from result: Get, and cupcake: Cupcake) {
        self.init(
            id: result.id,
            userName: result.userName,
            paymentMethod: result.paymentMethod,
            cupcake: cupcake,
            quantity: result.quantity,
            addSprinkles: result.addSprinkles,
            extraFrosting: result.extraFrosting,
            finalPrice: result.finalPrice,
            status: result.status,
            orderTime: result.orderTime,
            readyForDeliveryTime: result.readyForDeliveryTime,
            deliveredTime: result.deliveredTime
        )
    }
}

extension Order {
    func update(from result: Get) {
        if result.status != status {
            status = result.status
        }
        
        if result.readyForDeliveryTime != readyForDeliveryTime {
            readyForDeliveryTime = result.readyForDeliveryTime
        }
    }
}

extension Order {
    static var sampleOrders: [Order] {
        var orders = [Order]()
        
        for index in 0..<10 {
            let newOrder = Order(
                id: .init(),
                userName: "User \(index + 1)",
                paymentMethod: (index % 2 == 0) ? .cash : .creditCard,
                cupcake: .sampleCupcakes[index],
                quantity: (index + 1),
                addSprinkles: .random(),
                extraFrosting: .random(),
                finalPrice: .random(in: 5...50),
                status: (index % 2 == 0) ? .ordered : .readyForDelivery,
                orderTime: .now,
                readyForDeliveryTime: (index % 2 == 0) ? nil : .now
            )
            orders.append(newOrder)
        }
        
        return orders
    }
}
