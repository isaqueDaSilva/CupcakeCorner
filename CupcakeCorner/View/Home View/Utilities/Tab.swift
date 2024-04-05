//
//  Tab.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import Foundation
import SwiftUI

enum Tab: String {
    case buyView = "Home"
    case bagView = "Bag"
    
    var icon: Image {
        switch self {
        case .buyView:
            Icon.house.systemImage
        case .bagView:
            Icon.bag.systemImage
        }
    }
}
