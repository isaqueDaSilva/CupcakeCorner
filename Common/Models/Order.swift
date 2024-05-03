//
//  Order.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 23/04/24.
//

import Foundation
import SwiftData

@Model
final class Order {
    let id: UUID
    let userID: UUID
    let cupcakes: [UUID]
    let paymentMethod: PaymentMethod
    let deliveryAdress: String
    let finalPrice: Double
    let status: Status
    let orderTime: Date
    let outForDeliveryTime: Date?
    let deliveredTime: Date?
    
    init(
        id: UUID,
        userID: UUID,
        cupcakes: [UUID],
        paymentMethod: PaymentMethod,
        deliveryAdress: String,
        finalPrice: Double,
        status: Status,
        orderTime: Date = .now,
        outForDeliveryTime: Date? = nil,
        deliveredTime: Date? = nil
    ) {
        self.id = id
        self.userID = userID
        self.cupcakes = cupcakes
        self.paymentMethod = paymentMethod
        self.deliveryAdress = deliveryAdress
        self.finalPrice = finalPrice
        self.status = status
        self.orderTime = orderTime
        self.outForDeliveryTime = outForDeliveryTime
        self.deliveredTime = deliveredTime
    }
}
