//
//  ProfileView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    @StateObject private var pageController = PageController()
    
    var body: some View {
        Group {
            switch pageController.isAuthorized {
            case true:
                AccountView()
                    .matchedGeometryEffect(id: transitionKey, in: transition)
            case false:
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
        .environmentObject(pageController)
    }
}

#Preview {
    ProfileView()
}
