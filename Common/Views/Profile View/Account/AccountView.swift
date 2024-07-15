//
//  Profile.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftData
import SwiftUI

struct AccountView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var userRepo: UserRepositoty
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        AccountViewLoad()
            .navigationTitle("Account")
            .alert(
                viewModel.alertTitle,
                isPresented: $viewModel.showingAlert
            ) {
                if viewModel.isDeleteAccountAction {
                    Button("Cancel", role: .cancel) { }
                    
                    Button("Delete", role: .destructive) {
                        if let user = userRepo.user {
                            viewModel.deleteAccount(with: user, and: modelContext) {
                                userRepo.getUser(with: modelContext)
                            }
                        } else {
                            viewModel.displayError()
                        }
                    }
                }
                
                
            } message: {
                Text(viewModel.alertMessage)
            }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    let schema = Schema([
        User.self
    ])
    
    let container = try! ModelContainer(for: schema, configurations: config)
    
    let context = ModelContext(container)
    
    context.insert(User.sampleUser)
    print("Created User")
    
    try? context.save()
    print("Saved")
    
    let userRepo = UserRepositoty()
    userRepo.getUser(with: context)
    
    return NavigationStack {
        AccountView()
            .environment(\.modelContext, context)
            .environmentObject(userRepo)
    }
}
