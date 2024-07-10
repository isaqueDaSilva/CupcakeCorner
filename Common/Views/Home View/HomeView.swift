//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftData
import SwiftUI

/// The app's top level navigation tab view.
struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var userRepo = UserRepositoty()
    
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
        .environmentObject(userRepo)
        .onAppear {
            if userRepo.user == nil {
                userRepo.getUser(with: modelContext)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    let schema = Schema([
        User.self,
        Order.self,
        Cupcake.self
    ])
    
    let container = try? ModelContainer(for: schema, configurations: config)
    
    guard let container else { return HomeView() }
    
    let context = ModelContext(container)
    
    context.insert(User.sampleUser)
    print("Created User")
    
    for cupcake in Cupcake.sampleCupcakes {
        context.insert(cupcake)
    }
    print("Created Cupcakes")
    
    for order in Order.sampleOrders {
        context.insert(order)
    }
    print("Created Orders")
    
    try? context.save()
    print("Saved")
    
    return HomeView()
        .environment(\.modelContext, context)
}
