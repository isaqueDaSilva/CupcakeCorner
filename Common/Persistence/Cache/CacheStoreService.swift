//
//  CacheStoreService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/05/24.
//

import CoreData
import Foundation
import SwiftUI

/// An object for manager the Cache store services.
actor CacheStoreService {
    static let shared = CacheStoreService()
    
    /// Stores the current context used.
    private let container: NSPersistentContainer
    
    /// Stores the current contex for perform actions in instaces avaiables.
    private let context: NSManagedObjectContext
    
    /// Returns the current context utilized by app.
    func getContext() -> NSManagedObjectContext { context }
    
    /// Performing the save action, for save a new instance of some NSManagedObject.
    func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
    
    /// Performing the fetch action, for find instance saved in Core Data.
    /// - Parameter fetchResultsController: A controller that will be used for fetch instances saved in Core Data.
    /// - Returns: Retuns the all instances saved.
    func fetch<M: NSFetchRequestResult>(
        _ fetchResultsController: NSFetchedResultsController<M>
    ) throws -> [M] {
        try fetchResultsController.performFetch()
        
        guard let models = fetchResultsController.fetchedObjects else {
            return []
        }
        
        return models
    }
    
    func fetchWithRequest<M: NSManagedObject>(
        for model: M.Type,
        with entityName: String
    ) throws -> [M] {
        let request = NSFetchRequest<M>(entityName: entityName)
        let models = try context.fetch(request)
        
        return models
    }
    
    /// Fetch all changes that will be occur in the entity specified by the controller parameter.
    /// - Parameters:
    ///   - controller: The controller that will be used for fetching the changes occured.
    ///   - model: The type of which model we want to search for.
    /// - Returns: Returns the changes that occurred.
    func fetchChanges<M: NSManagedObject>(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        by model: M.Type
    ) -> [M] {
        guard let models = controller.fetchedObjects as? [M] else { return [] }
        return models
    }
    
    /// Creates a new NSFetchedResultsController.
    /// - Parameter request: Specifies which NSFetchRequest will be used in the NSFetchedResultsController
    /// - Returns: Returns a new instace of NSFetchedResultsController created.
    nonisolated func fetchedResultController<M: NSFetchRequestResult>(
        _ request: NSFetchRequest<M>
    ) -> NSFetchedResultsController<M> {
        NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    /// Deleting an existing NSManagedObject.
    /// - Parameter model: The NSManagedObject will  want delete.
    func delete<M: NSManagedObject>(_ model: M) throws {
        self.context.delete(model)
        try self.save()
    }
    
    private init(inMemoryOnly: Bool = false) {
        self.container = NSPersistentContainer(name: "CacheStore")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        
        self.context = container.viewContext
        
        if inMemoryOnly {
            description.url = URL(filePath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if error != nil {
                print("Falied to loading Book entite.")
            }
        }
        
        context.name = "main"
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
}

extension CacheStoreService {
    static let preview: CacheStoreService = {
        let cacheStore = CacheStoreService(inMemoryOnly: true)
        
        for index in 0..<10 {
            Task {
                let context = await cacheStore.getContext()
                let cupcake = Cupcake(context: context)
                let image = UIImage(named: Icon.bag.rawValue)
                let imageData = image?.pngData()
                let ingredients = [
                    Int.random(in: 1000...10000),
                    Int.random(in: 1000...10000),
                    Int.random(in: 1000...10000),
                    Int.random(in: 1000...10000),
                    Int.random(in: 1000...10000)
                ]
                let ingredientsData = try? JSONEncoder().encode(ingredients)
                
                guard let imageData else { return }
                guard let ingredientsData else { return }
                
                cupcake.id = UUID()
                cupcake.flavor = "Cupcake \(index + 1)"
                cupcake.coverImage = imageData
                cupcake.ingredients = ingredientsData
                cupcake.price = Double.random(in: 0.1..<15.0)
                cupcake.createAt = .now
                
                try? await cacheStore.save()
            }
        }
        
        Task {
            let context = await cacheStore.getContext()
            let user = User(context: context)
            user.id = UUID()
            user.name = "Tim Cook"
            user.city = "Cupertino"
            user.email = "timcook@apple.com"
            user.fullAdress = "One Apple Park Way, Cupertino"
            user.zip = "CA 95014"
            user.paymentMethod = "Cash"
            user.role = "client"
            
            try? await cacheStore.save()
        }
        
        return cacheStore
    }()
}
