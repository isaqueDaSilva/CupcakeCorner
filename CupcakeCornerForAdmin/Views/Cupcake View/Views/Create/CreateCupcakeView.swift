//
//  CreateCupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 02/05/24.
//

import SwiftUI

struct CreateCupcakeView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var cacheStorage: CacheStorageService
    @StateObject private var viewModel = ViewModel()
    
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
            } createCupcake: { cupcake in
                try cacheStorage.update(or: cupcake)
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
}

#Preview {
    CreateCupcakeView()
        .environmentObject(CacheStorageService(inMemoryOnly: true))
}
