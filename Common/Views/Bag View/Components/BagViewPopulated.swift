//
//  BagViewPopulated.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
//

import SwiftUI

extension BagView {
    @ViewBuilder
    func BagViewPopulated() -> some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.orders, id: \.id) { order in
                    ItemCard(
                        name: OrderDescriptionService.displayName(order),
                        description: OrderDescriptionService.displayDescription(order),
                        image: order.cupcake?.image,
                        price: order.finalPrice
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    #if ADMIN
                    .contextMenu {
                        Button {
                            viewModel.sendUpdatedOrder(
                                for: userRepo.user?.id,
                                orderID: order.id,
                                and: order.status
                            )
                        } label: {
                            if order.status == .ordered {
                                Label("Mark as Ready For Delivery", systemImage: Icon.truck.rawValue)
                            } else if order.status == .readyForDelivery {
                                Label("Mark as Delivered", systemImage: Icon.shippingBox.rawValue)
                            }
                        }
                    }
                    #endif
                    .padding(.horizontal)
                }
            }
        }
        .refreshable {
            viewModel.reconnect(
                with: userRepo.user?.id,
                and: modelContex
            )
        }
        #if CLIENT
        .navigationTitle("Bag")
        #elseif ADMIN
        .navigationTitle("Client Orders")
        #endif
    }
}
