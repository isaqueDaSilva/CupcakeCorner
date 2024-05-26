//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct HomeView: View {
    private let cacheStore: CacheStoreService
    
    var body: some View {
        TabView {
            CupcakeView(cacheStore)
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
            
            BagView(cacheStore)
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
            
            ProfileView(cacheStore)
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
    
    init(_ cacheStore: CacheStoreService) {
        self.cacheStore = cacheStore
    }
}

#Preview {
    HomeView(.init(inMemoryOnly: true))
}
