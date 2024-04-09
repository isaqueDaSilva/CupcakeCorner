//
//  Profile.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftUI

extension ProfileView {
    @ViewBuilder
    func Profile() -> some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("Dummy Name")
                        .font(.title3)
                        .bold()
                    
                    Text("dummyemail@icloud.com")
                        .font(.subheadline)
                }
            }
            
            Section {
                NavigationLink(value: "abc") {
                    Text("Orders")
                }
                
                NavigationLink(value: "abc") {
                    Text("Favorites Cupcakes")
                }
            }
            
            Section {
                NavigationLink(value: "abc") {
                    Text("Main Shipping")
                }
                
                NavigationLink(value: "abc") {
                    Text("Main Payment")
                }
            }
        }
        .navigationTitle("Account")
        .toolbar {
            ActionButton(label: "OK") { }
        }
    }
}


#Preview {
    NavigationStack {
        ProfileView().Profile()
    }
}
