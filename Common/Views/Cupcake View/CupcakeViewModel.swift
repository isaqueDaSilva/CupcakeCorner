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
        
        /// The instance of the NSFetchedResultsController used for perform a fetch cupcakes.
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
        
        /// Perform a fetch request for gets new cupcakes from the backend service.
        private func getCupcakes() async throws -> [Cupcake.Get] {
            
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
            
            guard let newCupcakes = try? decoder.decode([Cupcake.Get].self, from: data) else {
                throw APIError.badDecoding
            }
            
            return newCupcakes
        }
        
        /// Caching new cupcakes that coming from the request.
        /// - Parameter cupcakes: All cupcakes that coming from the request.
        private func cachingCupcakes(_ cupcakes: [Cupcake.Get]) async throws {
            
            // Creates a new cupcake in Core Data.
            for newCupcake in cupcakes {
                let encoder = JSONEncoder()
                let ingredientsData = try encoder.encode(newCupcake.ingredients)
                
                let context = await cacheStore.getContext()
                let cupcake = Cupcake(context: context)
                cupcake.id = newCupcake.id
                cupcake.coverImage = newCupcake.coverImage
                cupcake.flavor = newCupcake.flavor
                cupcake.ingredients = ingredientsData
                cupcake.price = newCupcake.price
                cupcake.createAt = newCupcake.createdAt
                try await cacheStore.save()
            }
        }
        
        /// Peforming fetch action in the Cache Store for find intances saved of the cupcakes.
        /// - Returns: Retuns the all cupcakes instances saved in Cache Store.
        private func fetchCupcakes() async -> [Cupcake] {
            // Fetch the new cupcakes inserted
            guard let newCupcakes = try? await cacheStore.fetch(fetchedResultController) else {
                return []
            }
            
            return newCupcakes
        }
        
        /// Load the cupcakes for displays all for users.
        func loadCupcakes() {
            task = Task(priority: .background) {
                // Load the current cupcakes saved in cache.
                let currentCupcakesSaved = await fetchCupcakes()
                
                do {
                    // Fetch new cupcakes.
                    let newCupcakes = try await getCupcakes()
                    
                    // Checks if the cache store is empty.
                    if currentCupcakesSaved.isEmpty {
                        // If no empty, will peformed the delete action
                        // in all instances.
                        for cupcake in currentCupcakesSaved {
                            try await cacheStore.delete(cupcake)
                        }
                    }
                    
                    try await cachingCupcakes(newCupcakes)
                    
                    // Fetch new instances saved.
                    let cupcakesCached = await fetchCupcakes()
                    
                    // Load the new cupcakes in the "cupcakes" property
                    // and load the page for display them.
                    await MainActor.run {
                        self.cupcakes = cupcakesCached
                        self.viewState = .load
                    }
                } catch {
                    await MainActor.run {
                        self.error = AppAlert(
                            title: "Falied to load Cupcakes",
                            description: error.localizedDescription
                        )
                        self.cupcakes = currentCupcakesSaved
                        self.viewState = .load
                        self.showingError = true
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        init(inMemoryOnly: Bool = false) {
            self.cacheStore = inMemoryOnly ? .sharedInMemoryOnly : .shared
            
            let request = Cupcake.fetchRequest()
            request.sortDescriptors = []
            
            fetchedResultController = cacheStore.fetchedResultController(request)
            
            super.init()
            
            fetchedResultController.delegate = self
            loadCupcakes()
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
