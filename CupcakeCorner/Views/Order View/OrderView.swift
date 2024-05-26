//
//  OrderView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct OrderView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        List {
            Section {
                ProductHighlight(
                    flavor: viewModel.cupcake.wrappedFlavor,
                    image: viewModel.cupcake.wrappedCoverImage
                )
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color(uiColor: .systemGray6))
            
            Section {
                Text("How much cakes do you want?")
                    .headerSessionText()
                
                Stepper("Number of Cakes: \(viewModel.order.quantity)", value: $viewModel.order.quantity, in: 1...20)
            }
            .listRowSeparator(.hidden, edges: .top)
            
            Section {
                Text("Special Request")
                    .headerSessionText()
                
                SpecialRequestButton(
                    isActive: $viewModel.order.extraFrosting, 
                    price: viewModel.extraFrostingPrice,
                    requestName: "Extra Frosting"
                )
                
                SpecialRequestButton(
                    isActive: $viewModel.order.addSprinkles,
                    price: viewModel.addSprinklesPrice,
                    requestName: "Add Extra Sprinkles"
                )
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle("Order")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .inactive {
                viewModel.task?.cancel()
                viewModel.task = nil
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    ActionButton(
                        viewState: $viewModel.viewState,
                        label: "Make Order"
                    ) {
                        viewModel.makeOrder()
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                VStack {
                    InformationLabel(viewModel.subtotal)
                }
            }
        }
        .toolbarBackground(.visible, for: .automatic)
        .alert(
            viewModel.alert?.title ?? "No Title",
            isPresented: $viewModel.showingAlert
        ) {
            if viewModel.isSuccessed {
                Button("OK") {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alert?.description ?? "No Message")
        }

    }
    
    init(cupcake: Cupcake) {
        _viewModel = StateObject(wrappedValue: .init(cupcake: cupcake))
    }
}

//#Preview {
//    NavigationStack {
//        OrderView(cupcake: .sampleCupcakes[0])
//    }
//}
