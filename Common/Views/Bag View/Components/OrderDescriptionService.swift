//
//  OrderDescriptionService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//

import Foundation

enum OrderDescriptionService {
    static func displayName(_ name: String?) -> String {
        #if CLIENT
        return name ?? "No Flavor Saved"
        #elseif ADMIN
        return name ?? "Unknown Name"
        #endif
    }
    
    static func displayDescription(
        with quantity: Int,
        _ flavor: String?,
        _ isAddedSprinkles: Bool,
        _ isAddedExtraFrosting: Bool,
        _ status: Status,
        _ orderTime: Date,
        _ readyForDeliveryTime: Date?,
        _ deliveryTime: Date?,
        and paymentMethod: PaymentMethod?
    ) -> String {
        #if CLIENT
        let text = """
        Quantity: \(quantity)
        Add Sprinkles: \(isAddedSprinkles ? "Yes" : "No")
        Extra Frosting: \(isAddedExtraFrosting ? "Yes" : "No")
        Status: \(status.displayedName)
        Order Time: \(orderTime)
        Out For Delivery: \(readyForDeliveryTime?.dateString() ?? "N/A"),
        Delivered: \(deliveryTime?.dateString() ?? "N/A")
        Payment Method: \(paymentMethod?.displayedName ?? "No Payment Method Avaiable.")
        """
        return text
        
        #elseif ADMIN
        let text = """
        Payment Method: \(paymentMethod?.displayedName ?? "No Payment Method Avaiable.")
        \(flavor ?? "No Flavor Saved")
        Quantity: \(quantity)
        Add Sprinkles: \(isAddedSprinkles ? "Yes" : "No")
        Extra Frosting: \(isAddedExtraFrosting ? "Yes" : "No")
        Status: \(status.displayedName)
        Order Time: \(orderTime.dateString())
        Out For Delivery: \(readyForDeliveryTime?.dateString() ?? "N/A")
        Delivered: \(deliveryTime?.dateString() ?? "N/A")
        """
        
        return text
        #endif
    }
}
