//
//  UpdateAccountView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//

import SwiftUI

struct UpdateAccountView: View {
    @EnvironmentObject var userRepo: UserRepository
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            EditAccount(
                name: $viewModel.name,
                paymentMethod: $viewModel.paymentMethod,
                viewState: $viewModel.viewState,
                buttonLabel: "Update",
                isDisabled: true
            ) {
                if userRepo.user != nil {
                    viewModel.sendUpdate { updatedUser in
                        try await userRepo.update(with: updatedUser)
                    }
                }
            }
            .navigationTitle("Update Account")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .alert(
                viewModel.alert.title,
                isPresented: $viewModel.showingAlert
            ) {
                Button("OK") {
                    if viewModel.isSuccessed {
                        dismiss()
                    }
                }
            } message: {
                Text(viewModel.alert.message)
            }
        }
    }
    
    init(with name: String, and userPaymentMetod: PaymentMethod) {
        _viewModel = StateObject(
            wrappedValue: .init(with: name, and: userPaymentMetod)
        )
    }
}

#Preview {
    NavigationStack {
        UpdateAccountView(with: "Dummy User", and: .cash)
    }
}
