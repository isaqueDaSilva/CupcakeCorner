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
        var quantity: Int
        var extraFrosting: Bool
        var addSprinkles: Bool
        
        private let basePrice: Double
        
        var extraFrostingPrice: Double {
            Double(quantity) * 1.5
        }
        
        var addSprinklesPrice: Double {
            Double(quantity) / 2.0
        }
        
        var finalPrice: Double {
            var cupcakeCost: Double {
                basePrice * Double(quantity)
            }
            
            var extraFrostingTax: Double {
                extraFrosting ? extraFrostingPrice : 0
            }
            
            var addSprinklesTax: Double {
                addSprinkles ? addSprinklesPrice : 0
            }
            
            let finalPrice = cupcakeCost + extraFrostingTax + addSprinklesTax
            
            
            return finalPrice
        }
        
        enum CodingKeys: CodingKey {
            case cupcakeID
            case quantity
            case extraFrosting
            case addSprinkles
            case finalProce
        }
        
        func encode(to encoder: any Encoder) throws {
            var container: KeyedEncodingContainer<Order.Create.CodingKeys> = encoder.container(keyedBy: Order.Create.CodingKeys.self)
            try container.encode(self.cupcakeID, forKey: Order.Create.CodingKeys.cupcakeID)
            try container.encode(self.quantity, forKey: Order.Create.CodingKeys.quantity)
            try container.encode(self.extraFrosting, forKey: Order.Create.CodingKeys.extraFrosting)
            try container.encode(self.addSprinkles, forKey: Order.Create.CodingKeys.addSprinkles)
            try container.encode(self.finalPrice, forKey: Order.Create.CodingKeys.finalProce)
        }
        
        init(
            cupcake: UUID,
            quantity: Int,
            extraFrosting: Bool,
            addSprinkles: Bool,
            basePrice: Double
        ) {
            self.cupcakeID = cupcake
            self.quantity = quantity
            self.extraFrosting = extraFrosting
            self.addSprinkles = addSprinkles
            self.basePrice = basePrice
        }
    }
}
