//
//  AllOrdersView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//

import SwiftUI

struct AllOrdersView: View {
    @EnvironmentObject var orderRepo: OrderRepository
    
    var body: some View {
        VStack {
            OrderFilterPickerView(
                filter: $orderRepo.filteredOrderStatus,
                filerList: Status.allStatusCase
            )
            .labelsHidden()
            #if os(macOS)
            .padding(.top, 5)
            #endif
            
            ScrollView {
                Group {
                    if !orderRepo.orders.isEmpty {
                        ForEach(orderRepo.filteredOrder) { order in
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
                            .padding(.horizontal)
                        }
                    } else {
                        OrderEmptyView(with: .emptyOrders)
                            .containerRelativeFrame(.vertical)
                    }
                }
            }
        }
        .navigationTitle("All Orders")
        .onAppear {
            orderRepo.filteredOrderStatus = .ordered
        }
        .onDisappear {
            orderRepo.filteredOrderStatus = .ordered
        }
        #if os(macOS)
        .padding(.bottom)
        #endif
    }
}

#Preview {
    AllOrdersView()
        .environmentObject(OrderRepository(storageManager: .preview()))
}
