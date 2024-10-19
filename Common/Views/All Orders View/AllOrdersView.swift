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
            
            ScrollView {
                Group {
                    if !orderRepo.filteredOrder.isEmpty {
                        ForEach(orderRepo.filteredOrder) { order in
                            ItemCard(
                                name: order.title,
                                description: order.description,
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
    }
}

#if DEBUG
#Preview {
    AllOrdersView()
        .environmentObject(OrderRepository(storageManager: .preview()))
}
#endif
