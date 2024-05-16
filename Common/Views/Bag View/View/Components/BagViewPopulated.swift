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
        List {
            ForEach(viewModel.orders) { order in
                Section {
                    ItemCard(
                        name: viewModel.displayName(order),
                        description: viewModel.displayDescription(order),
                        imageData: order.cupcake.coverImage,
                        price: order.finalPrice
                    )
                }
                .listRowSeparator(.hidden)
                .listSectionSpacing(0)
                #if ADMIN
                .swipeActions {
                    Button {
                        var status: Status = .ordered
                        
                        if order.status == .ordered {
                            status = .outForDelivery
                        } else if order.status == .outForDelivery {
                            status = .delivered
                        }
                        
                        viewModel.updateOrder(with: order.id, status: status)
                    } label: {
                        if order.status == .ordered {
                            Icon.truck.systemImage
                        } else if order.status == .outForDelivery {
                            Icon.shippingBox.systemImage
                        }
                    }
                    .tint(order.status == .ordered ? .yellow : .green)

                }
                #endif
            }
        }
        .listStyle(.plain)
    }
}
