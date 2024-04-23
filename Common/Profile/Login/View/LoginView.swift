//
//  LoginView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var pageController: PageController
    
    @State private var viewModel = ViewModel()
    @State private var navigation = Navigation()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            Form {
                Section {
                    LabeledContent("Email:") {
                        TextField("Insert your email here...", text: $viewModel.email)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    LabeledContent("Passowrd:") {
                        SecureField("Insert your password here...", text: $viewModel.password)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.emailAddress)
                    }
                    
                    ActionButton(
                        viewState: $viewModel.viewState,
                        label: "Sign In",
                        width: .infinity
                    ) { 
                        viewModel.login {
                            pageController.setNewValue(true)
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
                        
                        Button {
                            navigation.append(true)
                        } label: {
                            Text("Create an Account")
                                .foregroundStyle(.blue)
                                .underline()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .navigationDestination(for: Bool.self) { _ in
                CreateAnAccount(navigation: $navigation)
            }
            #endif
            .alert(
                viewModel.error?.title ?? "No title",
                isPresented: $viewModel.showingError
            ) {
                
            } message: {
                Text(viewModel.error?.description ?? "No description")
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(PageController())
    }
}
