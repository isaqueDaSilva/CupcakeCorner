//
//  ProfileView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    @StateObject private var pageController: PageController
    
    var body: some View {
        NavigationStack {
            Group {
                if pageController.user == nil {
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
                } else {
                    if let user = pageController.user {
                        AccountView(user: user)
                            .matchedGeometryEffect(id: transitionKey, in: transition)
                    }
                }
            }
        }
    }
    
    init(inMemoryOnly: Bool = false) {
        _pageController = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    ProfileView(inMemoryOnly: true)
}
