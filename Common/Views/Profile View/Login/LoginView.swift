//
//  LoginView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        Form {
            Section {
                LabeledContent("Email:") {
                    TextField("Insert your email here...", text: $viewModel.loginCredentials.email)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                
                LabeledContent("Passowrd:") {
                    SecureField("Insert your password here...", text: $viewModel.loginCredentials.password)
                        .multilineTextAlignment(.trailing)
                        .textInputAutocapitalization(.never)
                }
                
                ActionButton(
                    viewState: $viewModel.viewState,
                    label: "Sign In",
                    width: .infinity
                ) {
                    viewModel.login()
                }
            }
        }
        .navigationTitle("Login")
        #if CLIENT
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Text("No Account?")
                        .bold()
                    
                    NavigationLink {
                        CreateAnAccount()
                    } label: {
                        Text("Create an Account")
                            .foregroundStyle(.blue)
                            .underline()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        #endif
        .alert(
            viewModel.error?.title ?? "No title",
            isPresented: $viewModel.showingError
        ) {
            
        } message: {
            Text(viewModel.error?.description ?? "No description")
        }
        .onChange(of: scenePhase) { _, newValue in
            if (newValue == .inactive) {
                viewModel.task?.cancel()
                viewModel.task = nil
            }
        }
    }
    
    init(inMemoryOnly: Bool = false) {
        _viewModel = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
