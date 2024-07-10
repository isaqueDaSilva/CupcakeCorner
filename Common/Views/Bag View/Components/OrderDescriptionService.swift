//
//  OrderDescriptionService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 16/06/24.
//

import Foundation

extension BagView {
    enum OrderDescriptionService {
        static func displayName(_ order: Order) -> String {
            #if CLIENT
            return order.cupcake?.flavor ?? "No Flavor Saved"
            #elseif ADMIN
            return order.userName
            #endif
        }
        
        static func displayDescription(_ order: Order) -> String {
            #if CLIENT
            let text = """
            Quantity: \(order.quantity)
            Add Sprinkles: \(order.addSprinkles ? "Yes" : "No")
            Extra Frosting: \(order.extraFrosting ? "Yes" : "No")
            Status: \(order.status.displayedName)
            Order Time: \(order.orderTime.dateString)
            Out For Delivery: \(order.readyForDeliveryTime?.dateString ?? "N/A")
            Payment Method: \(order.paymentMethod.displayedName)
            """
            return text
            
            #elseif ADMIN
            let text = """
            Payment Method: \(order.paymentMethod.displayedName)
            \(order.cupcake?.flavor ?? "No Flavor Saved")
            Quantity: \(order.quantity)
            Add Sprinkles: \(order.addSprinkles ? "Yes" : "No")
            Extra Frosting: \(order.extraFrosting ? "Yes" : "No")
            Status: \(order.status.displayedName)
            Order Time: \(order.orderTime.dateString)
            Out For Delivery: \(order.readyForDeliveryTime?.dateString ?? "N/A")
            """
            
            return text
            #endif
        }
    }
}
