//
//  Profile.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel: ViewModel
    
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
    
    init(inMemoryOnly: Bool = false, user: User) {
        _viewModel = StateObject(wrappedValue: .init(user: user, inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    ProfileView(inMemoryOnly: true)
}
