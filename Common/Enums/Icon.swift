//
//  Icon.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import Foundation
import SwiftUI

enum Icon: String {
    case house = "house"
    case bag = "bag"
    case shippingBox = "shippingbox"
    case personCircle = "person.circle"
    case bookmark = "bookmark"
    case bookmarkFill = "bookmark.fill"
    case chevronLeft = "chevron.left"
    case chevronRight = "chevron.right"
    
    var systemImage: Image {
        Image(systemName: self.rawValue)
    }
}
