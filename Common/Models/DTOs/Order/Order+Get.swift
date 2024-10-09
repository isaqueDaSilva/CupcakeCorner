//
//  Order+Get.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

extension Order {
    /// An  order representation for decoding data that coming from the API request when is finished.
    struct Get: DataResponse {
        let id: UUID
        let userName: String
        let paymentMethod: PaymentMethod?
        let cupcake: UUID?
        let quantity: Int
        let extraFrosting: Bool
        let addSprinkles: Bool
        let finalPrice: Double
        let status: Status
        let orderTime: Date
        let readyForDeliveryTime: Date?
        let deliveredTime: Date?
    }
}
