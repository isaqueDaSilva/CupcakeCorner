//
//  Login.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import SwiftUI

extension ProfileView {
    @ViewBuilder
    func Login() -> some View {
        Form {
            Section {
                LabeledContent("Email:") {
                    TextField("Insert your email here...", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Passowrd:") {
                    SecureField("Insert your password here...", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
//                ActionButton(
//                    label: "Sign In",
//                    width: .infinity
//                ) { }
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
                            .underline()
                    }
                }
            }
        }
        #endif
    }
}

#Preview {
    NavigationStack {
        ProfileView().Login()
    }
}
