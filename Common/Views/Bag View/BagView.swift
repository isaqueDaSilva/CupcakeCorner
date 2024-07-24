//
//  BagView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI
import SwiftData

struct BagView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var modelContex
    @EnvironmentObject var userRepo: UserRepositoty
    
    @StateObject var viewModel = ViewModel()
    @State private var userID: UUID?
    private var inMemoryOnly: Bool
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .load:
                    if !viewModel.orders.isEmpty {
                        BagViewPopulated()
                            .matchedGeometryEffect(id: transitionKey, in: transition)
                    } else {
                        BagViewEmpty()
                            .matchedGeometryEffect(id: transitionKey, in: transition)
                    }
                case .loading:
                    ProgressView()
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                case .faliedToLoad:
                    BagViewEmpty(with: .error)
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                }
            }
            .onAppear {
                guard !inMemoryOnly else {
                    try? viewModel.fetchOrders(with: modelContex)
                    return
                }
                
                if (userRepo.user != nil) && (viewModel.webSocketService == nil) {
                    viewModel.connect(with: userRepo.user?.id, and: modelContex)
                    userID = userRepo.user?.id
                } else {
                    viewModel.viewState = .load
                }
            }
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .background {
                    viewModel.disconnect(
                        with: userRepo.user?.id,
                        isInBackground: true
                    )
                }
            }
            .onChange(of: userRepo.user) { _, _ in
                if userRepo.user == nil {
                    viewModel.disconnect(
                        with: userID
                    )
                    
                    userID = nil
                    
                    viewModel.deleteAllOrders(with: modelContex)
                }
            }
            .toolbar {
                #if CLIENT
                ToolbarItem(placement: .bottomBar) {
                    InformationLabel(
                        viewModel.totalOfBag,
                        title: "Total of this bag:"
                    )
                }
                #endif
                
                if viewModel.orders.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        ReconnectButton()
                    }
                }
            }
            .alert(
                viewModel.alertTitle,
                isPresented: $viewModel.showingAlert
            ) {
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
    
    init(_ inMemoryOnly: Bool = false) {
        self.inMemoryOnly = inMemoryOnly
    }
}

extension BagView {
    @ViewBuilder
    func ReconnectButton() -> some View {
        Button {
            viewModel.reconnect(
                with: userRepo.user?.id,
                and: modelContex
            )
        } label: {
            Icon.arrowClockwise.systemImage
        }
        .disabled(viewModel.viewState == .loading)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try? ModelContainer(for: Order.self, configurations: config)
    
    guard let container else {
        return BagView(true)
            .environmentObject(UserRepositoty())
    }
    
    let context = ModelContext(container)
    
    for order in Order.sampleOrders {
        context.insert(order)
    }
    
    try? context.save()
    print("Orders Saved")
    
    return BagView(true)
        .environment(\.modelContext, context)
        .environmentObject(UserRepositoty())
}
