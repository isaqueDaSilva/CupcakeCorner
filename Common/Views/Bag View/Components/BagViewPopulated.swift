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
                        name: viewModel.displayName(order),
                        description: viewModel.displayDescription(order),
                        image: viewModel.getImage(from: order.cupcake.coverImage),
                        price: order.finalPrice
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    #if ADMIN
                    .contextMenu {
                        Button {
                            viewModel.updateOrder(for: order.id, with: order.status)
                        } label: {
                            if order.status == .ordered {
                                Label("Mark as Out For Delivery", systemImage: Icon.truck.rawValue)
                            } else if order.status == .outForDelivery {
                                Label("Mark as Delivered", systemImage: Icon.shippingBox.rawValue)
                            }
                        }
                    }
                    #endif
                    .padding(.horizontal)
                }
            }
        }
    }
}
