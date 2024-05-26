//
//  UpdateCupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import SwiftUI

struct UpdateCupcakeView: View {
    
    @Environment(\.scenePhase) var scenePhase
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
            viewModel.update {
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
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .inactive {
                viewModel.task?.cancel()
                viewModel.task = nil
            }
        }
    }
    
    init(cupcake: Cupcake, cacheStorage: CacheStoreService) {
        _viewModel = StateObject(
            wrappedValue: .init(
                cupcake: cupcake,
                cacheStorage: cacheStorage
            )
        )
    }
}

//#Preview {
//    UpdateCupcakeView(cupcake: .sampleCupcakes[0])
//}
