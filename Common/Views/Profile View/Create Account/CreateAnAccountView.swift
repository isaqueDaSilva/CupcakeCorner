//
//  CreateAnAccountView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftUI

struct CreateAnAccountView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        EditAccount(
            name: $viewModel.newUser.name,
            email: $viewModel.newUser.email,
            password: $viewModel.newUser.password,
            confirmPassword: $viewModel.newUser.confirmPassword,
            paymentMethod: $viewModel.newUser.paymentMethod,
            viewState: $viewModel.viewState,
            buttonLabel: "Create"
        ) {
            viewModel.createUser()
        }
        .navigationTitle("Create Account")
        .alert(
            viewModel.alertTitle,
            isPresented: $viewModel.showingAlert
        ) {
            Button("OK") {
                if viewModel.isSuccessed {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        CreateAnAccountView()
    }
}
