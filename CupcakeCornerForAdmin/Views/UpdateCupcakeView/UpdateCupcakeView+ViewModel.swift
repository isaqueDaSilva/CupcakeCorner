//
//  ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/3/24.
//


import Foundation
import NetworkHandler
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
        @Published var alert = AlertHandler()
        
        @Published private var imageData: Data? = nil
        
        @Published var pickerItemSelected: PhotosPickerItem? = nil {
            didSet {
                if let pickerItemSelected {
                    getImage(pickerItemSelected)
                }
            }
        }
        
        private func getImage(_ pickerItemSelected: PhotosPickerItem) {
            GetPhoto.get(with: pickerItemSelected) { [weak self] data in
                guard let self else { return }
                
                if let data {
                    DispatchQueue.main.async {
                        self.imageData = data
                        self.coverImage = Image(by: data)
                    }
                }
            }
        }
        
        func update(
            with cupcakeID: UUID?,
            makeUpdateRequest: @escaping @Sendable (Cupcake.Update) async throws -> Cupcake.Update,
            updatePersistenceStore: @escaping (Cupcake.Get) async throws -> Void,
            dismissScreen: @escaping () -> Void
        ) {
            Task {
                guard let cupcakeID else {
                    throw NetworkService.APIError.fieldsEmpty
                }
                
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    let updatedCupcake = Cupcake.Update(
                        coverImage: imageData,
                        flavor: flavor,
                        ingredients: ingredients,
                        price: price
                    )
                    
                    let updatedCupcakeRequest = try await makeUpdateRequest(updatedCupcake)
                    let cupcakeResult = try await UpdaterSender.send(updatedCupcakeRequest, for: cupcakeID)
                    
                    try await updatePersistenceStore(cupcakeResult)
                    
                    await MainActor.run {
                        self.viewState = .load
                        dismissScreen()
                    }
                    
                } catch let error {
                    await MainActor.run {
                        alert.setAlert(
                            with: "Falied to Update the Cupcake",
                            and: error.localizedDescription
                        )
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init(coverImage: Image, flavor: String, price: Double, ingredients: [String]) {
            _coverImage = Published(initialValue: coverImage)
            _flavor = Published(initialValue: flavor)
            _price = Published(initialValue: price)
            _ingredients = Published(initialValue: ingredients)
        }
    }
}
