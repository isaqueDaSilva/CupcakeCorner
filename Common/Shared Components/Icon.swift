//
//  Icon.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import SwiftUI

/// A representation of the all SF Symbols names that used in the App.
enum Icon: String {
    case house = "house"
    case trash = "trash"
    case rectangleAndArrow = "rectangle.portrait.and.arrow.right"
    case bag = "bag"
    case shippingBox = "shippingbox"
    case person = "person"
    case personSlash = "person.slash"
    case personCircle = "person.circle"
    case bookmark = "bookmark"
    case bookmarkFill = "bookmark.fill"
    case chevronLeft = "chevron.left"
    case chevronRight = "chevron.right"
    case chevronDown = "chevron.down"
    case questionmarkDiamond = "questionmark.diamond"
    case plusCircle = "plus.circle"
    case squareSlash = "square.slash"
    case truck = "truck.box"
    case magnifyingglass = "magnifyingglass"
    case arrowClockwise = "arrow.clockwise"
    case pencil = "pencil"
    case infoCircle = "info.circle"
    
    var systemImage: Image {
        Image(systemName: self.rawValue)
    }
}
