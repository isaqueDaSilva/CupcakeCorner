//
//  Tab.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import Foundation
import SwiftUI

enum Tab: String, Identifiable, CaseIterable {
    case buyView = "Buy"
    case bagView = "Bag"
    
    var id: String { self.rawValue }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .buyView:
            BuyView()
        case .bagView:
            BagView()
                .badge(10)
        }
    }
    
    var icon: Image {
        switch self {
        case .buyView:
            Icon.house.systemImage
        case .bagView:
            Icon.bag.systemImage
        }
    }
}
