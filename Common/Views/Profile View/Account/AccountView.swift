//
//  Profile.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ViewModel
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    var body: some View {
        AccountViewLoad()
            .navigationTitle("Account")
            .alert(
                viewModel.error?.title ?? "No Title",
                isPresented: $viewModel.showingError
            ) {
            } message: {
                Text(viewModel.error?.description ?? "No description.")
            }
            .onChange(of: scenePhase) { _, newValue in
                if (newValue == .inactive) {
                    viewModel.task?.cancel()
                    viewModel.task = nil
                }
            }
    }
    
    init(cacheStore: CacheStoreService, user: User) {
        _viewModel = StateObject(wrappedValue: .init(user: user, cacheStore: cacheStore))
    }
}

//#Preview {
//    NavigationStack {
//        AccountView().AccountViewLoad()
//            .environmentObject(PageController())
//            .environmentObject(CacheStorageService(inMemoryOnly: true))
//    }
//}
