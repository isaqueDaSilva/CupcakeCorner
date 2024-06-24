//
//  MainEntrypoint.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 07/05/24.
//

import SwiftUI

/// The main scene's entry point for the both targets .
struct MainEntrypoint: Scene {
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
    }
}
