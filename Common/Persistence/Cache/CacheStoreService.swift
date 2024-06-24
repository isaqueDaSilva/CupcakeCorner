//
//  CacheStoreService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/05/24.
//

import CoreData
import Foundation
import SwiftUI

/// A struct that provides a default cache service.
struct CacheStoreService {
    // MARK: - Shared Initializers -
    
    /// A default entrypoint for access the cache service.
    static let shared = CacheStoreService()
    
    /// Provides in memory cache service for uses in previews.
    static let preview: CacheStoreService = {
        let cacheStore = CacheStoreService(inMemoryOnly: true)
        
        cacheStore.makeChanges { context in
            for index in 0..<10 {
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
                
                let bool = Bool.random()
                let order = Order(context: context)
                order.id = UUID()
                order.addSprinkles = Bool.random()
                order.deliveredTime = bool ? Date.now : nil
                order.extraFrosting = Bool.random()
                order.finalPrice = Double.random(in: 0.1..<20.0)
                order.orderTime = Date.now
                order.outForDelivery = bool ? Date.now : nil
                order.quantity = Int16(Int.random(in: 1...20))
                order.status = bool ? Status.delivered.displayedName : Status.ordered.displayedName
                order.userName = "Tim Cook"
                order.cupcake = cupcake
                
                do {
                    try context.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
            
            let user = User(context: context)
            user.id = UUID()
            user.name = "Tim Cook"
            user.city = "Cupertino"
            user.email = "timcook@apple.com"
            user.fullAdress = "One Apple Park Way"
            user.zip = "CA 95014"
            user.paymentMethod = "Cash"
            user.role = "client"
        }
        
        return cacheStore
    }()
    
    // MARK: - Properties -
    /// A default persistent container.
    private let container: NSPersistentContainer
    
    // MARK: - Methods -
    
    /// Makes a change in the container, saving, updating or deleting
    /// a NSManagedObject.
    func makeChanges(
        _ action: @escaping (NSManagedObjectContext) -> Void
    ) {
        container.performBackgroundTask { context in
            guard context.hasChanges else { return }
            action(context)
        }
    }
    
    /// Makes a fetch action in the container for find all NSManagedObject saved.
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
        let models = try container.viewContext.fetch(request)
        
        return models
    }
    
    /// Makes a fetch action in the container for find all changes in all NSManagedObject saved.
    func fetchChanges<M: NSManagedObject>(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        by model: M.Type
    ) -> [M] {
        guard let models = controller.fetchedObjects as? [M] else { return [] }
        return models
    }
    
    /// Creates a new NSFetchedResultsController.
    func fetchedResultController<M: NSFetchRequestResult>(
        _ request: NSFetchRequest<M>
    ) -> NSFetchedResultsController<M> {
        NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    // MARK: - Internal Initializer -
    private init(inMemoryOnly: Bool = false) {
        self.container = NSPersistentContainer(name: "CacheStore")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        
        if inMemoryOnly {
            description.url = URL(filePath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if error != nil {
                print("Falied to loading CacheStore entite.")
            }
        }
    }
}
