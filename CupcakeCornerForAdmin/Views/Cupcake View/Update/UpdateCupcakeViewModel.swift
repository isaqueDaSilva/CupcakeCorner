//
//  UpdateCupcakeViewModel.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import Foundation
import SwiftData
import SwiftUI
import PhotosUI

extension UpdateCupcakeView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var coverImage: Image?
        @Published var price: Double
        @Published var flavor: String
        @Published var ingredients: [String]
        
        @Published var ingredientName = ""
        @Published var viewState: ViewState = .load
        @Published var showingError = false
        @Published var errorTitle = ""
        @Published var errorMessage = ""
        
        @Published var pickerItemSelected: PhotosPickerItem? = nil {
            didSet {
                if let pickerItemSelected {
                    getImage(pickerItemSelected)
                }
            }
        }
        
        private var imageData: Data? = nil
        
        private func getImage(_ pickerItemSelected: PhotosPickerItem) {
            GetPhoto.get(with: pickerItemSelected) { [weak self] data in
                guard let self else { return }
                
                if let data {
                    self.imageData = data
                    self.coverImage = Image(by: data)
                }
            }
        }
        
        func update(
            _ cupcake: Cupcake,
            with modelContext: ModelContext,
            _ completationHandler: @escaping (Cupcake) -> Void
        ) {
            Task(priority: .background) {
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    let updatedCupcake = CupcakeUpdater.update(
                        cupcake,
                        with: imageData,
                        flavor,
                        ingredients,
                        and: price
                    )
                    
                    let cupcakeResult = try await CupcakeUpdateSender.send(updatedCupcake, for: cupcake.id)
                    
                    if cupcakeResult.coverImage != cupcake.coverImage {
                        cupcake.coverImage = cupcakeResult.coverImage
                    }
                    
                    if cupcakeResult.flavor != cupcake.flavor {
                        cupcake.flavor = cupcakeResult.flavor
                    }
                    
                    if cupcakeResult.ingredients != cupcake.ingredients {
                        cupcake.ingredients = cupcakeResult.ingredients
                    }
                    
                    if cupcakeResult.price != cupcake.price {
                        cupcake.price = cupcakeResult.price
                    }
                    
                    try modelContext.save()
                    
                    await MainActor.run {
                        self.viewState = .load
                        completationHandler(cupcake)
                    }
                } catch let error {
                    await MainActor.run {
                        self.errorTitle = "Falied to Update the Cupcake"
                        self.errorMessage = error.localizedDescription
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init(cupcake: Cupcake) {
            _coverImage = Published(initialValue: cupcake.image)
            _flavor = Published(initialValue: cupcake.flavor)
            _price = Published(initialValue: cupcake.price)
            _ingredients = Published(initialValue: cupcake.ingredients)
        }
    }
}
