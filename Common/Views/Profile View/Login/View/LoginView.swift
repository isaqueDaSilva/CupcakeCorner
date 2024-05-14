//
//  LoginView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import SwiftUI

struct LoginView: View {
    #if CLIENT
    @Environment(\.dismiss) private var dismiss
    #endif
    
    @EnvironmentObject var pageController: PageController
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Email:") {
                        TextField("Insert your email here...", text: $viewModel.login.email)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    LabeledContent("Passowrd:") {
                        SecureField("Insert your password here...", text: $viewModel.login.password)
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
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(PageController())
    }
}
