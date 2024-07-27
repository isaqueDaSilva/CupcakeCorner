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
        LazyVStack(spacing: 10) {
            Group {
                if !viewModel.orderedOrder.isEmpty {
                    OrderList(
                        for: .ordered,
                        orderList: viewModel.orderedOrder,
                        isSectionFold: $isShowingOrderedOrderSection
                    )
                }
                
                if !viewModel.readyForDeliveryOrder.isEmpty {
                    OrderList(
                        for: .readyForDelivery,
                        orderList: viewModel.readyForDeliveryOrder,
                        isSectionFold: $isShowingReadyForDeliveryOrderSection
                    )
                }
            }
        }
        #if CLIENT
        .navigationTitle("Bag")
        #elseif ADMIN
        .navigationTitle("Client Orders")
        #endif
    }
}
