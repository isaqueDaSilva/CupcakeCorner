//
//  PageController.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 21/04/24.
//

import CoreData
import Foundation

/// An object that controls which page is displayed on ProfileView.
final class PageController: NSObject {
    /// Stores an instance of the user logged.
    var user: User?
    
    /// Stores an instance of the CacheStoreService
    let cacheStore: CacheStoreService
    
    /// The instance of the NSFetchedResultsController
    /// used for perform a fetch cupcakes.
    private let fetchedResultController: NSFetchedResultsController<User>
    
    
    /// Gets an instance of the User.
    private func getUser() {
        Task {
            do {
                // Fetch the all user saved in the cache.
                let fetchedUser = try await cacheStore.fetch(fetchedResultController)
                
                // Defines an user in the
                // "user" property if
                // the fetch user is no empty.
                if fetchedUser.isEmpty {
                    user = nil
                } else {
                    user = fetchedUser[0]
                }
            }
        }
    }
    
    init(cacheStore: CacheStoreService) {
        self.cacheStore = cacheStore
        
        let request = User.fetchRequest()
        request.sortDescriptors = []
        
        fetchedResultController = cacheStore.fetchedResultController(request)
        
        super.init()
        
        fetchedResultController.delegate = self
        getUser()
    }
}

extension PageController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        Task {
            let usersFetched = await cacheStore.fetchChanges(controller, by: User.self)
            
            if usersFetched.isEmpty {
                user = nil
            } else {
                user = usersFetched[0]
            }
        }
    }
}
