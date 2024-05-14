//
//  UpdateCupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import SwiftUI

struct UpdateCupcakeView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var cacheStorage: CacheStorageService
    
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
            } updateCupcake: { cupcake in
                try cacheStorage.update(or: cupcake)
            }
        }
    }
    
    init(cupcake: Cupcake.Get, inMemoryOnly: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: .init(
                cupcake: cupcake
            )
        )
    }
}

//#Preview {
//    UpdateCupcakeView(cupcake: Cupcake.sampleCupcake[0], inMemoryOnly: true)
//}
