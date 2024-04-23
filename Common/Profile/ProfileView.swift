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
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Group {
            switch viewModel.isAuthorized {
            case true:
                AccountView()
                    .matchedGeometryEffect(id: transitionKey, in: transition)
            case false:
                LoginView()
                    .animation(
                        .spring,
                        value: viewModel.isAuthorized
                    )
                    .transition(
                        .asymmetric(
                            insertion: AnyTransition.move(
                                edge: .leading
                            ),
                            removal: AnyTransition.move(
                                edge: .trailing
                            )
                        )
                    )
            }
        }
    }
}

#Preview {
    ProfileView()
}
