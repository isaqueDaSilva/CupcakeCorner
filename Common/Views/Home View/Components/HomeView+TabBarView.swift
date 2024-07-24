//
//  HomeView+TabBarForIOS.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 20/07/24.
//

import SwiftUI

#if os(iOS)
extension HomeView {
    @ViewBuilder
    func TabBarHomeView() -> some View {
        TabView {
            ForEach(TabSection.allCases(), id: \.id) { section in
                section.view()
                    .tabItem {
                        Label {
                            section.title
                        } icon: {
                            section.icon
                        }
                    }
                    .tag(section)
            }
        }
    }
}
#endif
