//
//  CreateCupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 02/05/24.
//

import SwiftUI

struct CreateCupcakeView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel: ViewModel
    
    var insert: ((Cupcake) -> Void)
    
    var body: some View {
        EditCupcake(
            navigationTitle: "Create",
            coverImage: viewModel.coverImage,
            pickerItemSelected: $viewModel.pickerItemSelected,
            flavorName: $viewModel.cupcake.flavor,
            price: $viewModel.cupcake.price,
            ingredients: $viewModel.cupcake.ingredients,
            viewState: $viewModel.viewState
        ) { dismiss in
            viewModel.create(with: modelContext) { cupcake in
                insert(cupcake)
                dismiss()
            }
        }
        .alert(
            viewModel.errorTitle,
            isPresented: $viewModel.showingError
        ) {
            
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    init(inMemoryOnly: Bool = false, insert: @escaping (Cupcake) -> Void) {
        _viewModel = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
        self.insert = insert
    }
}

#Preview {
    CreateCupcakeView(inMemoryOnly: true) { _ in }
}
