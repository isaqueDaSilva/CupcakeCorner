//
//  MainEntrypoint.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 07/05/24.
//

import SwiftUI
import SwiftData

struct MainEntrypoint: Scene {
    private let container: ModelContainer
    
    @State private var isSplashViewPresented = true
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isSplashViewPresented {
                    CupcakeCornerSplashView(isSplashViewShowing: $isSplashViewPresented)
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                } else {
                    HomeView()
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                }
            }
        }
        .modelContainer(container)
        .modelContext(container.mainContext)
    }
    
    init() {
        do {
            container = try ModelContainer(for: User.self, Order.self, Cupcake.self)
        } catch {
            fatalError("Failed to create ModelContainer for User, Order and Cupcake.")
        }
    }
}
