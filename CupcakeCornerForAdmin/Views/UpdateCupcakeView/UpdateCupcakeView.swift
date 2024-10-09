//
//  UpdateCupcakeView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/3/24.
//


import SwiftUI

struct UpdateCupcakeView: View {
    @EnvironmentObject private var cupcakeRepo: CupcakeRepository
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        EditCupcake(
            pickerItemSelected: $viewModel.pickerItemSelected,
            flavorName: $viewModel.flavor,
            price: $viewModel.price,
            ingredients: $viewModel.ingredients,
            viewState: $viewModel.viewState,
            navigationTitle: "Update",
            coverImage: viewModel.coverImage
        ) { dismiss in
            viewModel.update(with: cupcakeRepo.selectedCupcake?.id) { updateRequest in
                try await cupcakeRepo.makeUpdateRequest(with: updateRequest)
            } updatePersistenceStore: { updateResult in
                try await cupcakeRepo.update(with: updateResult)
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
    
    init(
        coverImage: Image?,
        flavor: String?,
        price: Double?,
        ingredients: [String]?
    ) {
        _viewModel = StateObject(
            wrappedValue: .init(
                coverImage: coverImage ?? Icon.questionmarkDiamond.systemImage,
                flavor: flavor ?? "Unknown Flavor",
                price: price ?? 0.0,
                ingredients: ingredients ?? []
            )
        )
    }
}

#Preview {
    UpdateCupcakeView(
        coverImage: Icon.arrowClockwise.systemImage,
        flavor: "Chocolate",
        price: .random(in: 1...10),
        ingredients: ["String", "Stri", "S"]
    )
}
