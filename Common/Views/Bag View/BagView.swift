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
    
    @StateObject var viewModel: ViewModel
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    @AppStorage("is_showing_ordered_order_section")
    var isShowingOrderedOrderSection = false
    
    @AppStorage("is_showing_ready_for_delivery_section")
    var isShowingReadyForDeliveryOrderSection = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    switch viewModel.viewState {
                    case .load:
                        switch viewModel.orders.isEmpty {
                        case true:
                            BagViewEmpty()
                                .containerRelativeFrame(.vertical)
                                .matchedGeometryEffect(id: transitionKey, in: transition)
                        case false:
                            BagViewPopulated()
                                .matchedGeometryEffect(id: transitionKey, in: transition)
                        }
                    case .loading:
                        ProgressView()
                            .containerRelativeFrame(.vertical)
                            .matchedGeometryEffect(id: transitionKey, in: transition)
                    case .faliedToLoad:
                        BagViewEmpty(with: .error)
                            .containerRelativeFrame(.vertical)
                            .matchedGeometryEffect(id: transitionKey, in: transition)
                    }
                }
            }
            .onAppear {
                if viewModel.webSocketService == nil {
                    viewModel.connect(with: userRepo.user?.id, and: modelContex)
                }
            }
            .refreshable {
                viewModel.reconnect(
                    with: userRepo.user?.id,
                    and: modelContex
                )
            }
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .background {
                    viewModel.disconnect(
                        isInBackground: true
                    )
                }
            }
            .onChange(of: userRepo.user) { _, _ in
                if userRepo.user == nil {
                    viewModel.disconnect()
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
        _viewModel = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
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
