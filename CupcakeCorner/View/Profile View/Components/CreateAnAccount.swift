//
//  CreateAnAccount.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftUI

extension ProfileView {
    @ViewBuilder
    func CreateAccount() -> some View {
        Form {
            Section("User Information") {
                LabeledContent("Name:") {
                    TextField("Insert your name here...", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Email:") {
                    TextField("Insert your email here...", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Password:") {
                    SecureField("Create a Password", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Confirm:") {
                    SecureField("Confirm your password", text: $name)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Section("Adress") {
                LabeledContent("Street:") {
                    TextField("Insert your Street here...", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("City:") {
                    TextField("Insert your City here...", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Zip Code:") {
                    TextField("Insert your Zip Code here...", text: $name)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .navigationTitle("Create Account")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ActionButton(label: "Create") { }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView().CreateAccount()
    }
}
