//
//  CupcakeViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import CoreData
import Foundation
import SwiftUI

extension CupcakeView {
    /// An object that discrible how the CupcakeView handle with some action.
    final class ViewModel: NSObject, ObservableObject {
        
        /// All cupcakes avaiable.
        @Published var cupcakes = [Cupcake]()
        
        /// Current state of the view.
        @Published var viewState: ViewState = .loading
        
        /// Indicates whether an error is being displayed.
        @Published var showingError = false
        
        /// Represents which error that will be displayed.
        @Published var error: AppAlert?
        
        #if ADMIN
        /// Indicates whether the view for creating a new cupcake is active.
        @Published var showingCreateNewCupcakeView = false
        #endif
        
        /// The instance of the NSFetchedResultsController
        /// used for perform a fetch cupcakes.
        private var fetchedResultController: NSFetchedResultsController<Cupcake>
        
        /// Stores an instance of the CacheStoreService
        let cacheStore: CacheStoreService
        
        /// Stores an Task instance, indicating
        /// that an asynchronous task can be run.
        var task: Task<Void, Never>? = nil
        
        #if CLIENT
        /// Returns a most recent cupcake created.
        var newestCupcake: Cupcake? {
            cupcakes.min(by: { $0.wrappedCreationDate > $1.wrappedCreationDate })
        }
        #endif
        
        /// Perform a fetch request for gets new cupcakes from the backend.
        func getCupcakes() {
            task = Task(priority: .background) {
                do {
                    // Creates a new instance of the Network Service
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/cupcake/all",
                        httpMethod: .get,
                        type: .getData
                    )
                    
                    // Performing a fetch for new cupcakes.
                    let (data, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    // Decoding the cupcakes.
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let newCupcakes = try decoder.decode([Cupcake.Get].self, from: data)
                    
                    // Fetching the cupcakes saved in Core Data
                    let cupcakesSaved = try await cacheStore.fetch(fetchedResultController)
                    
                    // Deleting the cupcakes saved
                    for cupcake in cupcakesSaved {
                        try await cacheStore.delete(cupcake)
                    }
                    
                    // Creates a new cupcake in Core Data.
                    for newCupcake in newCupcakes {
                        let context = await cacheStore.getContext()
                        let cupcake = Cupcake(context: context)
                        cupcake.id = newCupcake.id
                        cupcake.coverImage = newCupcake.coverImage
                        cupcake.flavor = newCupcake.flavor
                        cupcake.ingredients = newCupcake.ingredients.joined(separator: ", ")
                        cupcake.price = newCupcake.price
                        cupcake.createAt = newCupcake.createdAt
                        try await cacheStore.save()
                    }
                    
                    // Fetch the new cupcakes inserted
                    let newCupcakesSaved = try await cacheStore.fetch(fetchedResultController)
                    
                    // Load the new cupcakes in the "cupcakes" property
                    // and load the page for display them.
                    await MainActor.run {
                        self.cupcakes = newCupcakesSaved
                        self.viewState = .load
                    }
                    
                } catch let error {
                    // If some error occur, an alert will be displayed.
                    await MainActor.run {
                        self.error = AppAlert(title: "Falied to load Cupcakes", description: error.localizedDescription)
                        self.viewState = .load
                        self.showingError = true
                    }
                }
            }
        }
        
        init(store: CacheStoreService) {
            self.cacheStore = store
            let request = Cupcake.fetchRequest()
            request.sortDescriptors = []
            
            fetchedResultController = store.fetchedResultController(request)
            
            super.init()
            
            fetchedResultController.delegate = self
            getCupcakes()
        }
    }
}

extension CupcakeView.ViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        Task {
            let newCupcakes = await cacheStore.fetchChanges(controller, by: Cupcake.self)
            
            await MainActor.run {
                cupcakes = newCupcakes
            }
        }
    }
}
