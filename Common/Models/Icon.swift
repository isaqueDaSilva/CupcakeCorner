//
//  Icon.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import Foundation
import SwiftUI

/// A representation model of the all SF Symbols used in the App.
enum Icon: String {
    case house = "house"
    case bag = "bag"
    case shippingBox = "shippingbox"
    case person = "person"
    case personSlash = "person.slash"
    case bookmark = "bookmark"
    case bookmarkFill = "bookmark.fill"
    case chevronLeft = "chevron.left"
    case chevronRight = "chevron.right"
    case questionmarkDiamond = "questionmark.diamond"
    case plusCircle = "plus.circle"
    case squareSlash = "square.slash"
    case truck = "truck.box"
    case magnifyingglass = "magnifyingglass"
    
    var systemImage: Image {
        Image(systemName: self.rawValue)
    }
}
