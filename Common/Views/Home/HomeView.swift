//
//  HomeView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userRepo: UserRepository
    @EnvironmentObject private var cupcakeRepo: CupcakeRepository
    @EnvironmentObject private var orderRepo: OrderRepository
    
    @State private var tabSelected: TabSelection = .cupcakes
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    var body: some View {
        Group {
            switch userRepo.user {
            case .some(_):
                tabs
                    .matchedGeometryEffect(id: transitionKey, in: transition)
            case .none:
                LoginView()
                    .matchedGeometryEffect(id: transitionKey, in: transition)
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: .move(
                                edge: .leading
                            ),
                            removal: .move(
                                edge: .trailing
                            )
                        ).animation(.spring())
                    )
            }
        }
        .environmentObject(userRepo)
        .environmentObject(cupcakeRepo)
        .environmentObject(orderRepo)
    }
}

extension HomeView {
    @ViewBuilder
    private var tabs: some View {
        TabView(selection: $tabSelected) {
            Tab(
                TabSelection.cupcakes.title,
                systemImage: TabSelection.cupcakes.iconName,
                value: .cupcakes
            ) {
                TabSelection.cupcakes.view()
            }
            
            Tab(TabSelection.orders.title, systemImage: TabSelection.orders.iconName, value: .orders) {
                TabSelection.orders.view()
            }
            
            Tab(
                TabSelection.profile.title,
                systemImage: TabSelection.profile.iconName,
                value: .profile
            ) {
                TabSelection.profile.view()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    let manager = StorageManager.preview()
    
    HomeView()
        .environmentObject(UserRepository(storageManager: manager))
        .environmentObject(OrderRepository(storageManager: manager))
        .environmentObject(CupcakeRepository(storageManager: manager))
}
