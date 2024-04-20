//
//  CreateAnAccount.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftUI

struct CreateAnAccount: View {
    @Binding var navigation: Navigation
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Form {
            Section("User Information") {
                LabeledContent("Name:") {
                    TextField("Insert your name here...", text: $viewModel.name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Email:") {
                    TextField("Insert your email here...", text: $viewModel.email)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Password:") {
                    SecureField("Create a Password", text: $viewModel.password)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Confirm:") {
                    SecureField("Confirm your password", text: $viewModel.confirmPassword)
                        .multilineTextAlignment(.trailing)
                }
                
                #if CLIENT
                LabeledContent("Payment Method") {
                    Picker("Payment Method", selection: $viewModel.paymentMethod) {
                        ForEach(PaymentMethod.allCases) { method in
                            if method != .isAdmin {
                                Text(method.rawValue)
                            }
                        }
                    }
                    .labelsHidden()
                }
                #endif
            }
            
            #if CLIENT
            Section("Adress") {
                LabeledContent("Street:") {
                    TextField("Insert your Street here...", text: $viewModel.street)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("City:") {
                    TextField("Insert your City here...", text: $viewModel.city)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Zip Code:") {
                    TextField("Insert your Zip Code here...", text: $viewModel.zip)
                        .multilineTextAlignment(.trailing)
                }
            }
            #endif
            
            Section {
                ActionButton(
                    viewState: $viewModel.viewState,
                    label: "Create",
                    width: .infinity
                ) { 
                    viewModel.createUser {
                        navigation.remove()
                    }
                }
            }
            .listSectionSpacing(.compact)
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Create Account")
        .alert(
            viewModel.error?.title ?? "No Title.",
            isPresented: $viewModel.showingError
        ) {
        } message: {
            Text(viewModel.error?.description ?? "No Description...")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigation.remove()
                } label: {
                    HStack {
                        Icon.chevronLeft.systemImage
                        Text("Back")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateAnAccount(navigation: .constant(Navigation()))
    }
}
