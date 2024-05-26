//
//  ProfileView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct ProfileView: View {
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    private var pageController: PageController
    
    var body: some View {
        NavigationStack {
            Group {
                if let user = pageController.user {
                    AccountView(cacheStore: pageController.cacheStore, user: user)
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                } else {
                    LoginView(cacheStorage: pageController.cacheStore)
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
        }
    }
    
    init(_ cacheStore: CacheStoreService) {
        self.pageController = .init(cacheStore: cacheStore)
    }
}

//#Preview {
//    ProfileView()
//        .environmentObject(CacheStorageService(inMemoryOnly: true))
//}
