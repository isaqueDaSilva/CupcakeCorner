//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            CupcakeView()
                .tabItem {
                    Label(
                        title: {
                            #if CLIENT
                            Text("Buy")
                            #elseif ADMIN
                            Text("Cupcakes")
                            #endif
                        }, icon: {
                            Icon.house.systemImage
                        }
                    )
                }
                .tag("Cupcakes")
            
            BagView()
                .tabItem {
                    Label(
                        title: {
                            #if CLIENT
                            Text("Bag")
                            #elseif ADMIN
                            Text("Orders")
                            #endif
                        }, icon: {
                            Icon.bag.systemImage
                        }
                    )
                }
                .tag("Orders")
            
            ProfileView()
                .tabItem {
                    Label(
                        title: {
                            Text("Profile")
                        }, icon: {
                            Icon.person.systemImage
                        }
                    )
                }
                .tag("Profile")
        }
    }
}

#Preview {
    HomeView()
}
