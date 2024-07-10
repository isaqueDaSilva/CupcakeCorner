//
//  ProfileView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var userRepo: UserRepositoty
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    @State private var viewState: ViewState = .loading
    
    var body: some View {
        NavigationStack {
            Group {
                if userRepo.user != nil {
                    AccountView()
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                } else {
                    LoginView {
                        viewState = .loading
                    } endAction: {
                        viewState = .load
                    }
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
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserRepositoty())
}
