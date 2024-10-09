//
//  LoginView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/6/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userRepo: UserRepository
    
    @FocusState var focusedField: FocusedField?
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(.cupcakeLogo)
                    .resizable()
                    .scaledToFit()
                    #if os(iOS)
                    .frame(width: 200, height: 200)
                    #endif
                
                #if os(iOS)
                fields_iOS
                #elseif os(macOS)
                fields_macOS
                #endif
                
                ActionButton(
                    viewState: $viewModel.viewState,
                    label: "Sign In",
                    width: .infinity
                ) {
                    loginAction()
                }
                .padding(.bottom)
                
                Spacer()
                Spacer()
                Spacer()
            }
            .padding()
            .navigationTitle("Login")
            #if CLIENT && os(iOS)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    createAccountButton
                }
            }
            #elseif CLIENT && os(macOS)
            .safeAreaInset(edge: .bottom) {
                createAccountButton
                    .padding(.bottom)
            }
            #endif
            .alert(
                viewModel.alert.title,
                isPresented: $viewModel.showingError
            ) { } message: {
                Text(viewModel.alert.message)
            }
        }
    }
}

#if os(iOS)
extension LoginView {
    @ViewBuilder
    private var fields_iOS: some View {
        VStack {
            TextFieldFocused(
                focusedField: $focusedField,
                focusedFieldValue: .email,
                fieldType: .textField(
                    "Insert your email here...",
                    $viewModel.loginCredentials.email
                ),
                keyboardType: .emailAddress,
                isAutocorrectionDisabled: true
            )
            
            TextFieldFocused(
                focusedField: $focusedField,
                focusedFieldValue: .password,
                fieldType: .secureField(
                    "Insert your password here...",
                    $viewModel.loginCredentials.password
                ),
                isAutocorrectionDisabled: true
            )
        }
    }
}
#endif

#if os(macOS)
extension LoginView {
    @ViewBuilder
    private var fields_macOS: some View {
        VStack {
            TextFieldFocused(
                focusedField: $focusedField,
                focusedFieldValue: .email,
                fieldType: .textField(
                    "Insert your email here...",
                    $viewModel.loginCredentials.email
                ),
                isAutocorrectionDisabled: true
            )
            
            TextFieldFocused(
                focusedField: $focusedField,
                focusedFieldValue: .password,
                fieldType: .secureField(
                    "Insert your password here...",
                    $viewModel.loginCredentials.password
                ),
                isAutocorrectionDisabled: true
            )
        }
    }
}
#endif

extension LoginView {
    @ViewBuilder
    private var createAccountButton: some View {
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

extension LoginView {
    enum FocusedField: Hashable {
        case email
        case password
    }
}

extension LoginView {
    func loginAction() {
        if viewModel.loginCredentials.email.isEmpty {
            focusedField = .email
        } else if viewModel.loginCredentials.password.isEmpty {
            focusedField = .password
        } else {
            viewModel.login { user in
                try await userRepo.insert(user)
            }
        }
    }
}

#Preview {
    LoginView()
}
