//
//  TabSelection.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/07/24.
//

import Foundation
import SwiftUI

extension HomeView {
    enum TabSection: Hashable {
        case cupcakes
        case orders
        case profile
    }
}

extension HomeView.TabSection: Identifiable {
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

extension HomeView.TabSection {
    var title: Text {
        switch self {
        case .cupcakes:
        #if CLIENT
        Text("Buy")
        #elseif ADMIN
        Text("Cupcakes")
        #endif
        case .orders:
        #if CLIENT
        Text("Bag")
        #elseif ADMIN
        Text("Orders")
        #endif
        case .profile:
        Text("Profile")
        }
    }
}

extension HomeView.TabSection {
    var icon: Image {
        switch self {
        case .cupcakes:
            Icon.house.systemImage
        case .orders:
            Icon.bag.systemImage
        case .profile:
            Icon.person.systemImage
        }
    }
}

extension HomeView.TabSection {
    @MainActor @ViewBuilder
    func view() -> some View {
        switch self {
        case .cupcakes:
            CupcakeView()
        case .orders:
            BagView()
        case .profile:
            ProfileView()
        }
    }
}

extension HomeView.TabSection {
    static func allCases() -> [HomeView.TabSection] {
        [.cupcakes, .orders, .profile]
    }
}
