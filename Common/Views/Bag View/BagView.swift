//
//  BagView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//

import SwiftUI

struct BagView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var userRepo: UserRepository
    @EnvironmentObject var cupcakeRepo: CupcakeRepository
    @EnvironmentObject var orderRepo: OrderRepository
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    @State private var viewDisplayedCount = 0
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                OrderFilterPickerView(
                    filter: $orderRepo.filteredOrderStatus,
                    filerList: Status.allCases
                )
                .labelsHidden()
                
                ScrollView {
                    Group {
                        switch viewModel.viewState {
                        case .load:
                            orderListPopulated
                        case .loading:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .containerRelativeFrame(.vertical)
                                .matchedGeometryEffect(id: transitionKey, in: transition)
                        case .faliedToLoad:
                            if orderRepo.filteredOrder.isEmpty {
                                OrderEmptyView(with: .error)
                                    .containerRelativeFrame(.vertical)
                                    .matchedGeometryEffect(id: transitionKey, in: transition)
                            } else {
                                orderListPopulated
                            }
                        }
                    }
                }
            }
            #if CLIENT
            .navigationTitle("Bag")
            #elseif ADMIN
            .navigationTitle("Client Orders")
            #endif
            .onAppear {
                viewDisplayedCount += 1
                
                if viewModel.wsService == nil && viewDisplayedCount == 1 {
                    startConnection()
                }
                
                orderRepo.newOrdersCount = 0
            }
            .refreshable {
                restartConnection()
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
                }
            }
            #if CLIENT
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    InformationLabel(
                        orderRepo.totalOfBag,
                        title: "Total of this bag:"
                    )
                }
            }
            #endif
            .alert(
                viewModel.alert.title,
                isPresented: $viewModel.showingAlert
            ) {
            } message: {
                Text(viewModel.alert.message)
            }
        }
    }
}

extension BagView {
    private func startConnection() {
        viewModel.connectWS()
        handleWithMessages()
    }
    
    private func restartConnection() {
        viewModel.disconnect()
        startConnection()
    }
    
    private func handleWithMessages() {
        viewModel.handleWithMessages { newOrder in
            if let cupcakeID = newOrder.cupcake {
                let cupcake = cupcakeRepo.cupcakes[cupcakeID]
                try await orderRepo.insert(newOrder, and: cupcake)
            } else {
                try await orderRepo.insert(newOrder, and: nil)
            }
        } load: { orders in
            try await orderRepo.load(with: orders)
        } update: { updatedOrder in
            try await orderRepo.update(with: updatedOrder)
        } failureCompletation: {
            try await orderRepo.load()
        }
    }
}

extension BagView {
    @ViewBuilder
    private var orderList: some View {
        Group {
            if !orderRepo.filteredOrder.isEmpty {
                ForEach(orderRepo.filteredOrder, id: \.id) { order in
                    ItemCard(
                        name: OrderDescriptionService.displayName(order.userName),
                        description: OrderDescriptionService.displayDescription(
                            with: order.quantity,
                            order.cupcake?.flavor,
                            order.addSprinkles,
                            order.extraFrosting,
                            order.status,
                            order.orderTime,
                            order.readyForDeliveryTime,
                            order.deliveredTime,
                            and: order.paymentMethod
                        ),
                        image: order.cupcake?.image,
                        price: order.finalPrice
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    #if ADMIN
                    .contextMenu {
                        changeOrderStatusButton(
                            with: order.id,
                            and: order.status
                        )
                    }
                    #endif
                    .padding(.horizontal)
                }
            } else {
                OrderEmptyView(with: .emptyOrders)
                    .containerRelativeFrame(.vertical)
            }
        }
    }
}

#if ADMIN
extension BagView {
    @ViewBuilder
    private func changeOrderStatusButton(
        with orderID: UUID,
        and status: Status
    ) -> some View {
        Button {
            viewModel.sendUpdatedOrder(
                with: orderID,
                and: status
            )
        } label: {
            if status == .ordered {
                Label(
                    "Mark as Ready For Delivery",
                    systemImage: Icon.truck.rawValue
                )
            } else if status == .readyForDelivery {
                Label(
                    "Mark as Delivered",
                    systemImage: Icon.shippingBox.rawValue
                )
            }
        }
    }
}
#endif

extension BagView {
    @ViewBuilder
    private var orderListPopulated: some View {
        LazyVStack(spacing: 10) {
            orderList
        }
    }
}

#if DEBUG
#Preview {
    let manager = StorageManager.preview()
    
    BagView()
        .environmentObject(CupcakeRepository(storageManager: manager))
        .environmentObject(OrderRepository(storageManager: manager))
        .environmentObject(UserRepository(storageManager: manager))
}
#endif
