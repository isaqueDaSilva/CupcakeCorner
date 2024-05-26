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
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        List {
            Section {
                VStack {
                    CoverImageView(coverImage: viewModel.cupcake.wrappedCoverImage)
                }
                .frame(maxWidth: .infinity)
            }
            
            Section("Informations:") {
                Text(viewModel.cupcake.wrappedFlavor)
                
                Text(viewModel.cupcake.price.currency)
            }
            
            Section("Ingredients") {
                ForEach(viewModel.cupcake.wrappedIngredients, id: \.self) {
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
                }
            }
        }
        .toolbar {
            Button("Edit") {
                viewModel.showingEditView = true
            }
        }
        .sheet(isPresented: $viewModel.showingEditView) {
            UpdateCupcakeView(cupcake: viewModel.cupcake, cacheStorage: viewModel.cacheStore)
        }
        .onChange(of: scenePhase) { _ , newValue in
            if newValue == .inactive {
                viewModel.task?.cancel()
                viewModel.task = nil
            }
        }
    }
    
    init(cupcake: Cupcake, cacheStore: CacheStoreService) {
        _viewModel = StateObject(
            wrappedValue: .init(
                cupcake: cupcake,
                cacheStorage: cacheStore
            )
        )
    }
}

//#Preview {
//    CupcakeDetailView(cupcake: .sampleCupcakes[0])
//}
