//
//  CreateCupcakeView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//

import SwiftUI

struct CreateCupcakeView: View {
    @EnvironmentObject var cupcakeRepo: CupcakeRepository
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        EditCupcake(
            pickerItemSelected: $viewModel.pickerItemSelected,
            flavorName: $viewModel.cupcake.flavor,
            price: $viewModel.cupcake.price,
            ingredients: $viewModel.cupcake.ingredients,
            viewState: $viewModel.viewState,
            navigationTitle: "Create",
            coverImage: viewModel.coverImage
        ) { dismiss in
            viewModel.create { newCupcake in
                try await cupcakeRepo.insert(newCupcake)
            } dismissScreen: {
                dismiss()
            }
        }
        .alert(
            viewModel.alert.title,
            isPresented: $viewModel.showingError
        ) {
            
        } message: {
            Text(viewModel.alert.message)
        }
    }
}

#Preview {
    let manager = StorageManager.preview(isInsertingData: false)
    
    CreateCupcakeView()
        .environmentObject(CupcakeRepository(storageManager: manager))
}
