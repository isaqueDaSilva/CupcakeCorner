//
//  AccountView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//

import Charts
import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userRepo: UserRepository
    @EnvironmentObject var orderRepo: OrderRepository
    @EnvironmentObject var cupcakeRepo: CupcakeRepository
    
    @State private var viewDisplayedCount = 0
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    userInfo
                    
                    #if CLIENT
                    mainPaymentDescription
                    #elseif ADMIN
                    createAccountButton
                    #endif
                    
                    allOrdersButton
                    
                    demonstrativeChart
                        .padding(.top)
                    
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .environmentObject(userRepo)
            .environmentObject(orderRepo)
            .navigationDestination(for: User?.self) { user in
                if let user {
                    UpdateAccountView(with: user.name, and: user.paymentMethod)
                }
            }
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
            UpdateAccountView(
                with: userRepo.user?.name ?? "No User Saved",
                and: userRepo.user?.paymentMethod ?? .cash
            )
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
extension AccountView {
    @ViewBuilder
    private var mainPaymentDescription: some View {
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

extension AccountView {
    private var text: String {
        #if ADMIN
        return "Cupcake Sales"
        #elseif CLIENT
        return "Total Purchases"
        #endif
    }
    
    @ViewBuilder
    private var demonstrativeChart: some View {
        VStack(alignment: .leading) {
            Text(text)
                .bold()
            
            Text("Total: \(cupcakeRepo.totalSales)")
                .headerSessionText(
                    font: .footnote,
                    color: .secondary
                )
            
            Chart {
                RuleMark(y: .value("Average", cupcakeRepo.avarge))
                    .foregroundStyle(.mint)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                
                ForEach(cupcakeRepo.cupcakeList, id: \.id) { cupcake in
                    BarMark(
                        x: .value(
                            "Cupcakes",
                            cupcake.flavor
                        ),
                        y: .value(
                            "Sale numbers",
                            cupcake.salesQuantity
                        )
                    )
                }
                .foregroundStyle(Color.pink.gradient)
                .cornerRadius(5)
            }
            .frame(height: 200)
            
            HStack {
                Image(systemName: "line.diagonal")
                    .rotationEffect(Angle(degrees: 45))
                    .foregroundColor(.mint)
                
                Text("Avarge")
                    .headerSessionText(
                        font: .caption2,
                        color: .secondary
                    )
            }
        }
    }
}

#if DEBUG
#Preview {
    let manager = StorageManager.preview()
    
    AccountView()
        .environmentObject(UserRepository(storageManager: manager))
        .environmentObject(OrderRepository(storageManager: manager))
        .environmentObject(CupcakeRepository(storageManager: manager))
}
#endif
