//
//  TabSection.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/6/24.
//

import Foundation
import SwiftUI

extension HomeView {
    enum TabSelection: Hashable, CaseIterable {
        case cupcakes
        case orders
        case profile
    }
}

extension HomeView.TabSelection: Identifiable {
    var id: String {
        switch self {
        case .cupcakes:
            "Cupcakes"
        case .orders:
            "Orders"
        case .profile:
            "Profile"
        }
    }
}

extension HomeView.TabSelection {
    var title: String {
        switch self {
        case .cupcakes:
        #if CLIENT
        "Buy"
        #elseif ADMIN
        "Cupcakes"
        #endif
        case .orders:
        #if CLIENT
        "Bag"
        #elseif ADMIN
        "Orders"
        #endif
        case .profile:
        "Profile"
        }
    }
}

extension HomeView.TabSelection {
    var titleView: Text {
        Text(self.title)
    }
}

extension HomeView.TabSelection {
    var iconName: String {
        switch self {
        case .cupcakes:
            Icon.house.rawValue
        case .orders:
            Icon.bag.rawValue
        case .profile:
            Icon.person.rawValue
        }
    }
}

extension HomeView.TabSelection {
    @MainActor @ViewBuilder
    func view() -> some View {
        switch self {
        case .cupcakes:
            CupcakeView()
        case .orders:
            BagView()
        case .profile:
            AccountView()
        }
    }
}
