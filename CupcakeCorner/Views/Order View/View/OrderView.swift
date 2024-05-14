//
//  OrderView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI
import SwiftData

struct OrderView: View {
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        List {
            Section {
                ProductHighlight(
                    flavor: viewModel.cupcake.flavor,
                    imageData: viewModel.cupcake.coverImage
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    ActionButton(
                        viewState: $viewModel.viewState,
                        label: "Add to Bag"
                    ) {
                        
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                VStack {
                    InformationLabel(viewModel.order.finalPrice)
                }
            }
        }
        .toolbarBackground(.visible, for: .automatic)
    }
    
    init(cupcake: Cupcake) {
        _viewModel = StateObject(wrappedValue: .init(cupcake: cupcake))
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: Cupcake.self, configurations: config)
        let modelContext = ModelContext(modelContainer)
        
        modelContext.insert(Cupcake.sampleCupcakes[0])
        let decripitor = FetchDescriptor<Cupcake>()
        let cupcakes = try modelContext.fetch(decripitor)
        
        return NavigationStack {
            OrderView(cupcake: cupcakes[0])
        }
    } catch let error {
        return EmptyView()
    }
}
