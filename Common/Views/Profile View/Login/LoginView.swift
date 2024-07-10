//
//  LoginView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject private var userRepo: UserRepositoty
    
    @StateObject private var viewModel: ViewModel
    
    var startAction: () -> Void
    var endAction: () -> Void
    
    var body: some View {
        Form {
            Section {
                LabeledContent("Email:") {
                    TextField("Insert your email here...", text: $viewModel.loginCredentials.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Passowrd:") {
                    SecureField("Insert your password here...", text: $viewModel.loginCredentials.password)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.trailing)
                }
                
                ActionButton(
                    viewState: $viewModel.viewState,
                    label: "Sign In",
                    width: .infinity
                ) {
                    startAction()
                    viewModel.login(with: modelContext) {
                        userRepo.getUser(with: modelContext)
                        endAction()
                    }
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
                        CreateAnAccountView()
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
            viewModel.errorTitle,
            isPresented: $viewModel.showingError
        ) { } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    init(
        inMemoryOnly: Bool = false,
        _ startAction: @escaping () -> Void,
        endAction: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
        self.startAction = startAction
        self.endAction = endAction
    }
}

#Preview {
    NavigationStack {
        LoginView(inMemoryOnly: true) { } endAction: { }
            .environmentObject(UserRepositoty())
    }
}
