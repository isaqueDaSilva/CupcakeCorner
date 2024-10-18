//
//  CupcakeDetailView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 9/30/24.
//

import SwiftUI

struct CupcakeDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.itsAnIPadDevice) private var itsAnIpadDevice
    
    @EnvironmentObject private var cupcakeRepo: CupcakeRepository
    
    @State private var showUpdateView = false
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                CoverImageView(coverImage: cupcakeRepo.selectedCupcake?.image)
                    .padding(.bottom)
                
                Text("Cupcake Information:")
                    .headerSessionText(
                        font: itsAnIpadDevice ? .title3.bold() : .headline,
                        color: .secondary
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LabeledDescription(
                    with: "Flavor",
                    and: cupcakeRepo.selectedCupcake?.flavor ?? "Unknown Flvaor"
                )
                
                LabeledDescription(
                    with: "Price",
                    and: cupcakeRepo.selectedCupcake?.price.currency ?? "Unknown Price"
                )
                .padding(.bottom)
                
                Text("Ingredients:")
                    .headerSessionText(
                        font: itsAnIpadDevice ? .title3.bold() : .headline,
                        color: .secondary
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .padding(.bottom, 5)
                
                ForEach(cupcakeRepo.selectedCupcake?.ingredients ?? [], id: \.self) { ingredient in
                    IngredientCell(
                        for: ingredient,
                        isLastIngredient: ingredient == cupcakeRepo.selectedCupcake?.ingredients.last
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            cupcakeRepo.set(nil)
        }
        .toolbar {
            Button(role: .destructive) {
                viewModel.showingConfirmation()
            } label: {
                Group {
                    if viewModel.viewState == .loading {
                        ProgressView()
                    } else {
                        Icon.trash.systemImage
                    }
                }
            }
            
            Button {
                showUpdateView = true
            } label: {
                Icon.pencil.systemImage
            }
        }
        .alert(
            viewModel.alert.title,
            isPresented: $viewModel.showingAlert
        ) {
            if viewModel.isErrorShowing {
                Button("OK") {
                    viewModel.isErrorShowing = false
                }
            } else {
                Button("Cancel", role: .cancel) { }
                
                Button("Delete", role: .destructive) {
                    viewModel.deleteCupcake(
                        with: cupcakeRepo.selectedCupcake?.id
                    ) {
                        try await cupcakeRepo.delete()
                        
                        await MainActor.run {
                            dismiss()
                        }
                    }
                }
            }
        } message: {
            Text(viewModel.alert.message)
        }
        .sheet(isPresented: $showUpdateView) {
            UpdateCupcakeView(
                coverImage: cupcakeRepo.selectedCupcake?.image,
                flavor: cupcakeRepo.selectedCupcake?.flavor,
                price: cupcakeRepo.selectedCupcake?.price,
                ingredients: cupcakeRepo.selectedCupcake?.ingredients
            )
            .environmentObject(cupcakeRepo)
        }
    }
}

extension CupcakeDetailView {
    @ViewBuilder
    func LabeledDescription(
        with title: String,
        and description: String
    ) -> some View {
        LabeledContent("\(title)", value: description)
            .font(itsAnIpadDevice ? .headline : nil)
            .softBackground()
    }
}

#Preview {
    @Previewable @Environment(\.verticalSizeClass) var vSizeClass
    
    @Previewable @Environment(\.horizontalSizeClass) var hSizeClass
    
    let manager = StorageManager.preview()
    
    var itsAnIPadDevice: Bool {
        vSizeClass == .regular && hSizeClass == .regular
    }
    
    NavigationStack {
        CupcakeDetailView()
            .environmentObject(CupcakeRepository(storageManager: manager))
            .environment(\.itsAnIPadDevice, itsAnIPadDevice)
    }
}
