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
                
                #if CLIENT
                NavigationLink(value: "abc") {
                    Text("Favorites Cupcakes")
                }
                #endif
            }
            
            Section {
                #if CLIENT
                NavigationLink(value: "abc") {
                    Text("Main Shipping")
                }
                
                NavigationLink(value: "abc") {
                    Text("Main Payment")
                }
                #elseif ADMIN
                NavigationLink(value: "abc") {
                    Text("Cupcakes")
                }
                
                NavigationLink(value: "abc") {
                    Text("Create New Admin User")
                }
                #endif
            }
        }
        .navigationTitle("Account")
        #if CLIENT
        .toolbar {
            //ActionButton(label: "OK") { }
        }
        #endif
    }
}


#Preview {
    NavigationStack {
        ProfileView().Profile()
    }
}
