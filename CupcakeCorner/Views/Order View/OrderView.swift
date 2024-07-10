//
//  OrderView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftData
import SwiftUI

struct OrderView: View {
    @EnvironmentObject private var userRepo: UserRepositoty
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        List {
            Section {
                ProductHighlight(
                    flavor: viewModel.cupcake.flavor,
                    image: viewModel.cupcake.image
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
                viewModel.disconnect()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    ActionButton(
                        viewState: $viewModel.viewState,
                        label: "Make Order",
                        isDisabled: (userRepo.user == nil)
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
            viewModel.alertTitle,
            isPresented: $viewModel.showingAlert
        ) {
            if viewModel.isSuccessed {
                Button("OK") {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }

    }
    
    init(cupcake: Cupcake) {
        _viewModel = StateObject(wrappedValue: .init(cupcake: cupcake))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    let schema = Schema([
        Cupcake.self
    ])
    
    let container = try! ModelContainer(for: schema, configurations: config)
    
    let context = ModelContext(container)
    
    for cupcake in Cupcake.sampleCupcakes {
        context.insert(cupcake)
    }
    print("Created Cupcakes")
    
    try? context.save()
    print("Saved")
    
    let descriptor = FetchDescriptor<Cupcake>()
    let cupcakes = try! context.fetch(descriptor)
    
    return NavigationStack {
        OrderView(cupcake: cupcakes[0])
            .environment(\.modelContext, context)
            .environmentObject(UserRepositoty())
    }
}
