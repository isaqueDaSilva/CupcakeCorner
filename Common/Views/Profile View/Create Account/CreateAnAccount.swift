//
//  CreateAnAccount.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftUI

struct CreateAnAccount: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        let _ = Self._printChanges()
        Form {
            Section("User Information") {
                LabeledContent("Name:") {
                    TextField("Insert your name here...", text: $viewModel.newUser.name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Email:") {
                    TextField("Insert your email here...", text: $viewModel.newUser.email)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.emailAddress)
                }
                
                LabeledContent("Password:") {
                    SecureField("Create a Password", text: $viewModel.newUser.password)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Confirm:") {
                    SecureField("Confirm your password", text: $viewModel.newUser.confirmPassword)
                        .multilineTextAlignment(.trailing)
                }
                
                #if CLIENT
                LabeledContent("Payment Method") {
                    Picker("Payment Method", selection: $viewModel.newUser.paymentMethod) {
                        ForEach(PaymentMethod.allCases, id: \.id) { method in
                            PaymentMethodSelector(method)
                        }
                    }
                    .labelsHidden()
                }
                #endif
            }
            
            #if CLIENT
            Section("Adress") {
                LabeledContent("Street:") {
                    TextField("Insert your Street here...", text: $viewModel.fullAdress)
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
                    viewModel.createUser()
                }
            }
            .listSectionSpacing(.compact)
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Create Account")
        .alert(
            "Account Created",
            isPresented: $viewModel.showingAlert
        ) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your account was created with success, click in OK and log in the system for gets the full access in the App.")
        }
        .onChange(of: scenePhase) { _ , newValue in
            if (newValue == .inactive) {
                viewModel.task?.cancel()
                viewModel.task = nil
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateAnAccount()
    }
}
