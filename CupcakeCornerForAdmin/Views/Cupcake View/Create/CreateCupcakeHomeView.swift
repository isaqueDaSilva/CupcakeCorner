//
//  CreateCupcakeHomeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 02/05/24.
//

import Foundation
import SwiftUI
import PhotosUI

extension CreateCupcakeView {
    /// An object that discrible how the CreateCupcakeView handle with some actions.
    final class ViewModel: ObservableObject {
        /// Stores an Cupcake.Create instance for creating a new cupcake.
        @Published var cupcake: Cupcake.Create
        
        /// Stores the view state of the Create button.
        @Published var viewState: ViewState = .load
        
        /// Stores an PhotoPickerItem value with the image data.
        @Published var pickerItemSelected: PhotosPickerItem? = nil {
            didSet {
                if let pickerItemSelected {
                    getImage(pickerItemSelected)
                }
            }
        }
        
        /// Stores an Images gets from the PhotosPickerItem.
        @Published var coverImage: UIImage? = nil
        
        /// Stores a value that indicating if an alert is  displaying or not.
        @Published var showingError = false
        @Published var error: AppAlert?
        
        var task: Task<Void, Never>? = nil
        
        /// Stores the CacheStoreService instance.
        private let cacheStorage: CacheStoreService
        
        /// Gets an Image from the PhotosPickerItem.
        /// - Parameter pickerItemSelected: An instance of the PhotosPickerItem,
        private func getImage(_ pickerItemSelected: PhotosPickerItem) {
            Task {
                // Loads the data and the image gets from the PhotosPickerItem
                let (data, image) = try await GetPhoto.getImage(pickerItemSelected)
                
                // Pass the data for coverImage property
                // of the Cupcake.Create instance
                // and the image for the coverImage instance.
                await MainActor.run {
                    if let data, let image {
                        self.cupcake.coverImage = data
                        coverImage = image
                    }
                }
            }
        }
        
        /// Creating a new cupcake on database.
        /// - Parameter completationHandler: Pass an function that will be execute after the creation request is successed.
        func create(
            _ completationHandler: @escaping () -> Void
        ) {
            task = Task(priority: .background) {
                do {
                    // Encode new cupcake
                    let encoder = JSONEncoder()
                    let cupcakeData = try encoder.encode(cupcake)
                    
                    // Gets the values for pass on HTTP header field request
                    // for gets an authorization into backend for continues the task.
                    let tokenValue = try KeychainService.retrive()
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    // Creates the Network Service for makes Request.
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/cupcake/create",
                        values: [
                            .init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization),
                            .init(value: "application/json", httpHeaderField: .contentType)
                        ],
                        httpMethod: .post,
                        type: .uploadData(cupcakeData)
                    )
                    
                    // Makes the request on backend service and gets the data and response
                    let (data, response) = try await request.run()
                    
                    // Checks if the status code on HTTPURLResponse is equal to 200 or success code.
                    // If no equal to 200, thow an error as bad response.
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    // Decode new Cupcake received from the network request
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let cupcakeResult = try decoder.decode(Cupcake.Get.self, from: data)
                    
                    // Gets the shared view context gets from the shared cache storage service.
                    let context = await cacheStorage.getContext()
                    
                    // Creates new cupcake instance.
                    let newCupcake = Cupcake(context: context)
                    newCupcake.id = cupcakeResult.id
                    newCupcake.coverImage = cupcakeResult.coverImage
                    newCupcake.flavor = cupcakeResult.flavor
                    newCupcake.ingredients = cupcakeResult.ingredients.joined(separator: ", ")
                    newCupcake.price = cupcakeResult.price
                    newCupcake.createAt = cupcakeResult.createdAt
                    
                    // Save the instance on Core Data
                    try await cacheStorage.save()
                    
                    // Dismiss the current view.
                    await MainActor.run {
                        self.viewState = .load
                        completationHandler()
                    }
                } catch let error {
                    // If the request failed the catch block is call and the error is lauched.
                    await MainActor.run {
                        self.error = AppAlert(title: "Falied to Create Cupcake", description: error.localizedDescription)
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init(
            cacheStorage: CacheStoreService
        ) {
            _cupcake = Published(
                initialValue: .init(
                    coverImage: .init(),
                    flavor: "",
                    ingredients: [],
                    price: 0
                )
            )
            
            self.cacheStorage = cacheStorage
        }
    }
}
