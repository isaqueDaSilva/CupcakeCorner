//
//  CupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import SwiftUI

struct CupcakeDetailView: View {
    @Environment(\.dismiss) var dismiss
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
                    viewModel.deleteCupcake {
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") {
                viewModel.showingEditView = true
            }
        }
        .sheet(isPresented: $viewModel.showingEditView) {
            UpdateCupcakeView(cupcake: viewModel.cupcake)
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
//    CupcakeView(cupcake: <#Cupcake#>)
//}
