//
//  Order.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation
import SwiftData

@Model
final class Order {
    #Unique<Order>([\.id])
    #Index<Order>([\.id])
    
    var id: UUID
    var userName: String
    var paymentMethod: PaymentMethod?
    
    @Relationship(deleteRule: .nullify, inverse: \Cupcake.orders)
    var cupcake: Cupcake?
    var quantity: Int
    var addSprinkles: Bool
    var extraFrosting: Bool
    var finalPrice: Double
    var status: Status
    var orderTime: Date
    var readyForDeliveryTime: Date?
    var deliveredTime: Date?
    
    private init(
        id: UUID,
        userName: String,
        paymentMethod: PaymentMethod?,
        cupcake: Cupcake?,
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
    convenience init(from result: Get, and cupcake: Cupcake?) {
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

extension Order: DataModel {
    typealias Result = Get
    
    static func create(from result: Get) -> Self {
        self.init(
            id: result.id,
            userName: result.userName,
            paymentMethod: result.paymentMethod,
            cupcake: nil,
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
    
    func addCupcake(_ cupcake: Cupcake?) throws -> Self {
        self.cupcake = cupcake
        
        cupcake?.orders?.append(self)
        try cupcake?.modelContext?.save()
        
        try self.modelContext?.save()
        
        return self
    }
}

extension Order {
    func update(from result: Get) -> Self {
        if result.status != status {
            status = result.status
        }
        
        if result.readyForDeliveryTime != readyForDeliveryTime {
            readyForDeliveryTime = result.readyForDeliveryTime
        }
        
        if result.deliveredTime != deliveredTime {
            deliveredTime = deliveredTime
        }
        
        return self
    }
}

// MARK: - Sample -
extension Order {
    static func makeSampleOrders(in context: ModelContext) throws {
        let fetchSampleCupcakes = FetchDescriptor<Cupcake>()
        let cupcakes = try context.fetch(fetchSampleCupcakes)
        
        for cupcake in cupcakes {
            let number = Int.random(in: 1...10)
            
            let newOrder = Order(
                id: .init(),
                userName: "User \(Int.random(in: 1...10))",
                paymentMethod: (number % 2 == 0) ? .cash : .creditCard,
                cupcake: cupcake,
                quantity: (number + 1),
                addSprinkles: .random(),
                extraFrosting: .random(),
                finalPrice: .random(in: 5...50),
                status: (number == 5 || number == 10) ? .delivered : (number % 2 == 0) ? .ordered : .readyForDelivery,
                orderTime: .randomDate(),
                readyForDeliveryTime: (number % 2 == 0) ? nil : (number == 5 || number == 10) ? .now : .now,
                deliveredTime: (number == 5 || number == 10) ? .now : nil
            )
            
            cupcake.orders?.append(newOrder)
            
            context.insert(newOrder)
        }
        
        try context.save()
    }
}
