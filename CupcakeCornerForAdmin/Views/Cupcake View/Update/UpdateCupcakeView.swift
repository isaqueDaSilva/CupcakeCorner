//
//  UpdateCupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import SwiftData
import SwiftUI

struct UpdateCupcakeView: View {
    @Binding var cupcake: Cupcake
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        EditCupcake(
            navigationTitle: "Update",
            coverImage: viewModel.coverImage,
            pickerItemSelected: $viewModel.pickerItemSelected,
            flavorName: $viewModel.flavor,
            price: $viewModel.price,
            ingredients: $viewModel.ingredients,
            viewState: $viewModel.viewState
        ) { dismiss in
            viewModel.update(cupcake, with: modelContext) { updatedCupcake in
                if updatedCupcake.coverImage != cupcake.coverImage {
                    cupcake.coverImage = updatedCupcake.coverImage
                }
                
                if updatedCupcake.flavor != cupcake.flavor {
                    cupcake.flavor = updatedCupcake.flavor
                }
                
                if updatedCupcake.ingredients != cupcake.ingredients {
                    cupcake.ingredients = updatedCupcake.ingredients
                }
                
                if updatedCupcake.price != cupcake.price {
                    cupcake.price = updatedCupcake.price
                }
            }
            
            dismiss()
        }
        .alert(
            viewModel.errorTitle,
            isPresented: $viewModel.showingError
        ) {
            
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    init(cupcake: Binding<Cupcake>, inMemoryOnly: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: .init(
                cupcake: cupcake.wrappedValue
            )
        )
        
        _cupcake = cupcake
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
    
    return UpdateCupcakeView(cupcake: .constant(cupcakes[0]))
        .environment(\.modelContext, context)

}

//#Preview {
//    UpdateCupcakeView(cupcake: .sampleCupcakes[0])
//}
