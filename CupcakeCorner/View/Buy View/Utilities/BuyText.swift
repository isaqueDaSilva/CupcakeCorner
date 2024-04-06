//
//  Text.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import Foundation
import SwiftUI

extension BuyView {
    enum BuyText: String {
        case freeShippingTitle = "Free Shipping"
        case freeShippingDescription = "From Friday to Sunday, in all locations in Cupertino."
        
        var text: Text {
            Text(self.rawValue)
        }
    }
}
