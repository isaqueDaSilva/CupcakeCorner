//
//  UpdateCupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import SwiftUI

struct UpdateCupcakeView: View {
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        EditCupcake(
            navigationTitle: "Update",
            coverImage: viewModel.coverImage,
            pickerItemSelected: $viewModel.pickerItemSelected,
            flavorName: $viewModel.cupcake.flavor,
            price: $viewModel.cupcake.price,
            ingredients: $viewModel.cupcake.ingredients,
            viewState: $viewModel.viewState
        ) { dismiss in
            viewModel.update {
                dismiss()
            }
        }
    }
    
    init(cupcake: Cupcake, inMemoryOnly: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: .init(
                cupcake: cupcake,
                inMemoryOnly: inMemoryOnly
            )
        )
    }
}

//#Preview {
//    UpdateCupcakeView(cupcake: Cupcake.sampleCupcake[0], inMemoryOnly: true)
//}
