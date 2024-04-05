//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            ForEach(Tab.allCases) { tab in
                tab.view
                    .tabItem {
                        Label(
                            title: { Text(tab.rawValue) },
                            icon: { tab.icon }
                        )
                    }
                    .tag(tab.id)
            }
        }
    }
}

#Preview {
    HomeView()
}
