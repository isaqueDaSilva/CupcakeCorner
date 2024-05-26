//
//  CupcakeViewModel.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import Foundation

extension CupcakeDetailView {
    /// An object that discrible how the CupcakeDetailView handle with some actions.
    final class ViewModel: ObservableObject {
        
        /// Stores a value that indicating if the edit view is active or not.
        @Published var showingEditView = false
        
        /// Stores the current value for the current view state
        @Published var viewState: ViewState = .load
        
        /// Stores a value that indicating if an alert is  displaying or not.
        @Published var showingAlert = false
        
        @Published var alert: AppAlert?
        var task: Task<Void, Never>? = nil
        
        /// Stores an Cupcake instance
        let cupcake: Cupcake
        
        /// Stores the CacheStoreService instance.
        let cacheStore: CacheStoreService
        
        /// Displaying the confirmation Alert.
        func showingConfirmation() {
            alert = AppAlert(
                title: "Delete Cupcake",
                description: "Are you sure you want to delete this cupcake?"
            )
            
            showingAlert = true
        }
        
        /// Deleting an Cupcake.
        /// - Parameter completation: Pass an function that will be execute after the deleting request is successed.
        func deleteCupcake(_ completation: @escaping () -> Void) {
            task = Task(priority: .background) {
                do {
                    // Defines the view state
                    // of the Delete Button as loading.
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    // Gets the token and the bearer value.
                    let tokenValue = try KeychainService.retrive()
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    // Checks if the cupcakeID is not empty.
                    guard let cupcakeID = cupcake.id else {
                        throw APIError.fieldsEmpty
                    }
                    
                    // Creates a new NetworkService instance.
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/cupcake/delete/\(cupcakeID)",
                        values: [.init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization)],
                        httpMethod: .delete,
                        type: .getData
                    )
                    
                    // Performs the deleting action on backend.
                    let (_, response) = try await request.run()
                    
                    // Checks if the response status code is equal to 200.
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    // Deleting the current cupcake instance from Core Data.
                    try await cacheStore.delete(cupcake)
                    
                    // Making the view state of the delete button load
                    // and calls the completation(the dismiss action).
                    await MainActor.run {
                        viewState = .load
                        completation()
                    }
                } catch let error {
                    // If some error occur, a alert is showing for user.
                    await MainActor.run {
                        self.alert = AppAlert(
                            title: "Falied to Delete Cupcake.",
                            description: error.localizedDescription
                        )
                        viewState = .load
                        showingAlert = true
                    }
                }
            }
        }
        
        init(cupcake: Cupcake, cacheStorage: CacheStoreService) {
            self.cupcake = cupcake
            self.cacheStore = cacheStorage
        }
    }
}
