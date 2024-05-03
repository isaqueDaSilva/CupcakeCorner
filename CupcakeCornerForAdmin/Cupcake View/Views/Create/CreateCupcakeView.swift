//
//  CreateCupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 02/05/24.
//

import SwiftUI

struct CreateCupcakeView: View {
    @StateObject private var viewModel: ViewModel
    
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
            viewModel.create {
                dismiss()
            }
        }
        .alert(
            viewModel.error?.title ?? "No Title",
            isPresented: $viewModel.showingError
        ) {
            
        } message: {
            Text(viewModel.error?.description ?? "No Description")
        }
    }
    
    init(inMemoryOnly: Bool = false) {
        _viewModel = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    CreateCupcakeView()
}
