//
//  AccountView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//


import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userRepo: UserRepository
    @EnvironmentObject var orderRepo: OrderRepository
    @EnvironmentObject var cupcakeRepo: CupcakeRepository
    
    @State private var viewDisplayedCount = 0
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    userInfo
                    
                    #if CLIENT
                    
                    #if os(iOS)
                    mainPaymentDescription_iOS
                    #elseif os(macOS)
                    mainPaymentDescription_macOS
                    #endif
                    
                    #elseif ADMIN
                    createAccountButton
                    #endif
                    
                    allOrdersButton
                    
                    DemonstrativeChart()
                        .padding(.top)

                }
                #if os(iOS)
                .padding(.horizontal)
                #elseif os(macOS)
                .padding()
                #endif
            }
            .environmentObject(userRepo)
            .environmentObject(orderRepo)
            .navigationTitle("Account")
            .onAppear {
                viewDisplayedCount += 1
                
                if orderRepo.orders.isEmpty && viewDisplayedCount == 1 {
                    let isCupcakeListEmpty = cupcakeRepo.cupcakes.isEmpty
                    viewModel.makeAction {
                        if isCupcakeListEmpty {
                            try await cupcakeRepo.load()
                        }
                        
                        try await orderRepo.load()
                    }
                }
            }
            .alert(
                viewModel.alert.title,
                isPresented: $viewModel.showingAlert
            ) {
                if !viewModel.isErrorShowing {
                    Button("Cancel", role: .cancel) { }
                    
                    Button("OK", role: .destructive) {
                        deleteAllInstances()
                    }
                } else {
                    Button("OK") {
                        viewModel.isErrorShowing = false
                    }
                }
            } message: {
                Text(viewModel.alert.message)
            }
            .toolbar {
                Button(role: .destructive) {
                    viewModel.isDeleteAccountAction = false
                    viewModel.displayAlert(
                        with: "Logout",
                        and: "Are you sure that you want to make logout action?"
                    )
                } label: {
                    switch viewModel.signOutViewState {
                    case .load, .faliedToLoad:
                        Icon.rectangleAndArrow.systemImage
                    case .loading:
                        ProgressView()
                    }
                }
                .disabled(viewModel.isDisabled)
                
                Button(role: .destructive) {
                    viewModel.isDeleteAccountAction = true
                    viewModel.displayAlert(
                        with: "Delete Accout",
                        and: "Are you sure that you want to delete your account?"
                    )
                } label: {
                    switch viewModel.deleteAccountViewState {
                    case .load, .faliedToLoad:
                        Icon.trash.systemImage
                    case .loading:
                        ProgressView()
                    }
                }
                .disabled(viewModel.isDisabled)
            }
        }
    }
}

extension AccountView {
    private func deleteAllInstances() {
        if userRepo.user != nil {
            viewModel.deleteAction {
                await withThrowingTaskGroup(of: Void.self) { task in
                    task.addTask {
                        try await orderRepo.deleteAll()
                    }
                    
                    task.addTask {
                        try await cupcakeRepo.deleteAll()
                    }
                }
                try await userRepo.delete()
            }
        } else {
            viewModel.displayAlert(with: "No user logged")
        }
    }
}

extension AccountView {
    @ViewBuilder
    private var userInfo: some View {
        NavigationLink {
            if let user = userRepo.user {
                UpdateAccountView(
                    with: user.name,
                    and: user.paymentMethod
                )
            }
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(userRepo.user?.name ?? "No User Saved")
                        .font(.title3)
                        .bold()
                    
                    Text(userRepo.user?.email ?? "No User Saved")
                        .font(.caption)
                }
                
                Icon.chevronRight.systemImage
                    .frame(
                        maxWidth: .infinity,
                        alignment: .trailing
                    )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .softBackground()
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(userRepo.user == nil)
    }
}

#if CLIENT
#if os(iOS)
extension AccountView {
    @ViewBuilder
    private var mainPaymentDescription_iOS: some View {
        LabeledContent("Main Payment:") {
            Text(
                userRepo.user?.paymentMethod.displayedName ?? "No User Saved"
            )
            .multilineTextAlignment(.trailing)
        }
        .softBackground()
    }
}
#endif

#if os(macOS)
extension AccountView {
    @ViewBuilder
    private var mainPaymentDescription_macOS: some View {
        HStack {
            HStack {
                Text("Main Payment")
                
                Text(
                    userRepo.user?.paymentMethod.displayedName ?? "No User Saved"
                )
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .softBackground()
        }
    }
}
#endif
#endif

#if ADMIN
extension AccountView {
    @ViewBuilder
    private var createAccountButton: some View {
        NavigationLink {
            CreateAnAccountView()
        } label: {
            HStack {
                Text("Create New Admin")
                
                Icon.chevronRight.systemImage
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .softBackground()
        }
        .buttonStyle(PlainButtonStyle())
    }
}
#endif

extension AccountView {
    @ViewBuilder
    private var allOrdersButton: some View {
        NavigationLink {
            AllOrdersView()
        } label: {
            HStack {
                Text("All Orders")
                
                Icon.chevronRight.systemImage
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .softBackground()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let manager = StorageManager.preview()
    
    AccountView()
        .environmentObject(UserRepository(storageManager: manager))
        .environmentObject(OrderRepository(storageManager: manager))
        .environmentObject(CupcakeRepository(storageManager: manager))
}
