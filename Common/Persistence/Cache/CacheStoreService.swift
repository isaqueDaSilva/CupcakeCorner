//
//  CacheStoreService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/05/24.
//

import CoreData
import Foundation

/// An object for manager the Cache store services.
actor CacheStoreService {
    static let shared = CacheStoreService()
    static let sharedInMemoryOnly = CacheStoreService(inMemoryOnly: true)
    
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
        self.context = container.viewContext
        
        if inMemoryOnly {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if error != nil {
                print("Falied to loading Book entite.")
            }
        }
        
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
