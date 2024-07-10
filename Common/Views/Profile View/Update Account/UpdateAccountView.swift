//
//  UpdateAccountView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/06/24.
//

import SwiftData
import SwiftUI

struct UpdateAccountView: View {
    @EnvironmentObject var userRepo: UserRepositoty
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            EditAccount(
                name: $viewModel.name,
                paymentMethod: $viewModel.paymentMethod,
                viewState: $viewModel.viewState,
                buttonLabel: "Update",
                isDisabled: true
            ) {
                if let user = userRepo.user {
                    viewModel.sendUpdate(with: user, and: modelContext) {
                        userRepo.getUser(with: modelContext)
                    }
                }
            }
            .navigationTitle("Update Account")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                viewModel.alertTitle,
                isPresented: $viewModel.showingAlert
            ) {
                Button("OK") {
                    if viewModel.isSuccessed {
                        dismiss()
                    }
                }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
    
    init(user: User) {
        _viewModel = StateObject(
            wrappedValue: .init(user: user)
        )
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
    
    let descriptor = FetchDescriptor<User>()
    let users = try! context.fetch(descriptor)
    
    return NavigationStack {
        UpdateAccountView(user: users[0])
            .environment(\.modelContext, context)
            .environmentObject(UserRepositoty())
    }
}
