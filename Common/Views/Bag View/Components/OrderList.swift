//
//  OrderList.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 26/07/24.
//

import SwiftData
import SwiftUI

extension BagView {
    @ViewBuilder
    func OrderList(
        for orderStatus: Status,
        orderList: [Order],
        isSectionFold: Binding<Bool>
    ) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(orderStatus.displayedName)
                .headerSessionText()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top])
            
            Button {
                withAnimation(.easeOut) {
                    isSectionFold.wrappedValue.toggle()
                }
            } label: {
                isSectionFold.wrappedValue ? Icon.chevronDown.systemImage : Icon.chevronRight.systemImage
            }
            .padding(.trailing)
        }
        
        if !isSectionFold.wrappedValue {
            ForEach(orderList, id: \.id) { order in
                ItemCard(
                    name: OrderDescriptionService.displayName(order),
                    description: OrderDescriptionService.displayDescription(order),
                    image: order.cupcake?.image,
                    price: order.finalPrice
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut, value: order)
                #if ADMIN
                .contextMenu {
                    Button {
                        viewModel.sendUpdatedOrder(
                            with: order.id,
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
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try? ModelContainer(for: Order.self, configurations: config)
    
    guard let container else {
        return BagView(true)
            .environmentObject(UserRepositoty())
    }
    
    let context = ModelContext(container)
    
    let orders = Order.sampleOrders
    
    for order in orders {
        context.insert(order)
    }
    
    try? context.save()
    print("Orders Saved")
    
    return ScrollView {
        BagView().OrderList(
            for: .delivered,
            orderList: orders,
            isSectionFold: .constant(false)
        )
    }
}
