//
//  CupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import SwiftUI

struct CupcakeDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject private var cacheStorage: CacheStorageService
    
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        List {
            Section {
                VStack {
                    CoverImageView(coverImage: viewModel.coverImage)
                }
                .frame(maxWidth: .infinity)
            }
            
            Section("Informations:") {
                Text(viewModel.cupcake.flavor)
                
                Text(viewModel.cupcake.price.currency)
            }
            
            Section("Ingredients") {
                ForEach(viewModel.cupcake.ingredients, id: \.self) {
                    Text($0)
                }
            }
            
            Section {
                Button("Delete cupcake", role: .destructive) {
                    viewModel.showingConfirmation()
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(viewModel.alert?.title ?? "No Title", isPresented: $viewModel.showingAlert) {
            Button("Cancel", role: .cancel) { }
            
            Button("Delete", role: .destructive) {
                viewModel.deleteCupcake {
                    dismiss()
                } deleteCupcake: { cupcake in
                    try cacheStorage.deleteCupcake(cupcake)
                }
            }
        }
        .toolbar {
            Button("Edit") {
                viewModel.showingEditView = true
            }
        }
        .sheet(isPresented: $viewModel.showingEditView) {
            UpdateCupcakeView(cupcake: viewModel.cupcake)
        }
        .onChange(of: scenePhase) { _ , newValue in
            if newValue == .inactive {
                viewModel.task?.cancel()
                viewModel.task = nil
            }
        }
    }
    
    init(cupcake: Cupcake.Get) {
        _viewModel = StateObject(
            wrappedValue: .init(
                cupcake: cupcake
            )
        )
    }
}

#Preview {
    CupcakeDetailView(cupcake: .sampleCupcakes[0])
}
