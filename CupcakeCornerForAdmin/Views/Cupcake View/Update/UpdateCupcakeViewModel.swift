//
//  UpdateCupcakeViewModel.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import Foundation
import SwiftUI
import PhotosUI

extension UpdateCupcakeView {
    final class ViewModel: ObservableObject {
        let cupcake: Cupcake
        
        @Published var coverImage: UIImage?
        @Published var price: Double
        @Published var flavor: String
        @Published var ingredients: [String]
        
        @Published var ingredientName = ""
        @Published var viewState: ViewState = .load
        @Published var showingError = false
        @Published var error: AppAlert?
        
        @Published var pickerItemSelected: PhotosPickerItem? = nil {
            didSet {
                if let pickerItemSelected {
                    getImage(pickerItemSelected)
                }
            }
        }
        
        @Published var task: Task<Void, Never>? = nil
        
        let cacheStorage: CacheStoreService
        
        func getImage(_ pickerItemSelected: PhotosPickerItem) {
            Task {
                let (_, image) = try await GetPhoto.getImage(pickerItemSelected)
                
                await MainActor.run {
                    if let image {
                        coverImage = image
                    }
                }
            }
        }
        
        func update(
            _ completationHandler: @escaping () -> Void
        ) {
            task = Task {
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    // Transform an image into data type.
                    let imageData = coverImage?.pngData()
                    
                    // Creates a new updated cupcake
                    let updatedCupcake = Cupcake.Update(
                        coverImage: imageData,
                        flavor: flavor,
                        ingredients: ingredients,
                        price: price
                    )
                    
                    // Encode the updated cupcake
                    let encoder = JSONEncoder()
                    let updatedCupcakeData = try encoder.encode(updatedCupcake)
                    
                    // Gets the values for pass on HTTP header field request
                    // for gets an authorization into backend for continues the task.
                    let tokenValue = try KeychainService.retrive()
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    // Checks if has the id for the cupcake.
                    guard let cupcakeID = cupcake.id else {
                        throw APIError.fieldsEmpty
                    }
                    
                    // Creates the Network Service for makes Request.
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/cupcake/update/\(cupcakeID)",
                        values: [
                            .init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization),
                            .init(value: "application/json", httpHeaderField: .contentType)
                        ],
                        httpMethod: .patch,
                        type: .uploadData(updatedCupcakeData)
                    )
                    
                    // Makes the request on backend service and gets the data and response
                    let (data, response) = try await request.run()
                    
                    // Checks if the status code on HTTPURLResponse is equal to 200 or success code.
                    // If no equal to 200, thow an error as bad response
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    // Creates a decoder and decode the data received from the request
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let cupcakeResult = try decoder.decode(Cupcake.Get.self, from: data)
                    
                    // Update the existing Cupcake
                    let ingredientsData = try encoder.encode(cupcakeResult.ingredients)
                    cupcake.coverImage = cupcakeResult.coverImage
                    cupcake.flavor = cupcakeResult.flavor
                    cupcake.ingredients = ingredientsData
                    cupcake.price = cupcakeResult.price
                    
                    // Save changes on Core Data.
                    try await cacheStorage.save()
                    
                    // Finish the work making the view state as load and calls the dismiss action.
                    await MainActor.run {
                        self.viewState = .load
                        completationHandler()
                    }
                } catch let error {
                    // If the request failed the catch block is call and the error is lauched.
                    await MainActor.run {
                        self.error = AppAlert(title: "Falied to Update the Cupcake", description: error.localizedDescription)
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init(cupcake: Cupcake, inMemoryOnly: Bool = false) {
            _coverImage = Published(initialValue: cupcake.wrappedCoverImage)
            _flavor = Published(initialValue: cupcake.wrappedFlavor)
            _price = Published(initialValue: cupcake.price)
            _ingredients = Published(initialValue: cupcake.wrappedIngredients)
            self.cupcake = cupcake
            
            self.cacheStorage = inMemoryOnly ? .sharedInMemoryOnly : .shared
        }
    }
}
