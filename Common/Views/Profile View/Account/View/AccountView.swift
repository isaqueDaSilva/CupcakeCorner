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
    
    @EnvironmentObject var pageController: PageController
    @EnvironmentObject var cacheStorage: CacheStorageService
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .load:
                AccountViewLoad()
            case .loading:
                ProgressView()
            case .faliedToLoad:
                AccountViewFaliedToLoad()
            }
        }
        .navigationTitle("Account")
        .onAppear {
            let user = cacheStorage.storage[0].user
            
            viewModel.setUser(user: user)
        }
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
}

#Preview {
    NavigationStack {
        AccountView().AccountViewLoad()
            .environmentObject(PageController())
            .environmentObject(CacheStorageService(inMemoryOnly: true))
    }
}
