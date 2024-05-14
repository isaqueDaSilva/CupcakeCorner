//
//  CacheStorageService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation
import SwiftData

final class CacheStorageService: ObservableObject {
    @Published var storage: CacheStorage?
    
    private let context: ModelContext
    
    func save() throws {
        try context.save()
    }
    
    private func create(new storage: CacheStorage) throws {
        context.insert(storage)
        try save()
    }
    
    private func get() throws -> [CacheStorage] {
        let descriptor = FetchDescriptor<CacheStorage>()
        
        let storage = try context.fetch(descriptor)
        
        guard !storage.isEmpty else {
            let storage = CacheStorage()
            try create(new: storage)
            
            let saveStorages = try get()
            
            return saveStorages
        }
        
        return storage
    }
    
    func update(
        with newUser: User.Get? = nil,
        and newCupcakes: [Cupcake.Get]? = nil,
        or singleCupcakeUpdated: Cupcake.Get? = nil
    ) throws {
        if let newUser {
            self.storage?.user = newUser
        }
        
        if let newCupcakes {
            if ((storage?.cupcakes.isEmpty) != nil) {
                storage?.cupcakes.append(contentsOf: newCupcakes)
            } else {
                storage?.cupcakes = newCupcakes
            }
        }
        
        if let singleCupcakeUpdated {
            guard let index = storage?.cupcakes.firstIndex(of: singleCupcakeUpdated) else {
                return
            }
            
            storage?.cupcakes.remove(at: index)
            storage?.cupcakes.insert(singleCupcakeUpdated, at: index)
        }
        
        try save()
    }
    
    func deleteUser(_ user: User.Get) throws {
        storage?.user = nil
        try save()
    }
    
    func deleteCupcake(_ cupcake: Cupcake.Get) throws {
        guard let index = storage?.cupcakes.firstIndex(of: cupcake) else {
            throw PersistenceDataError.notFound
        }
        
        storage?.cupcakes.remove(at: index)
    }
    
    init(inMemoryOnly: Bool = false) {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: inMemoryOnly)
            let container = try ModelContainer(for: CacheStorage.self, configurations: config)
            self.context = ModelContext(container)
            
            let savedStorages = try get()
            
            _storage = Published(initialValue: savedStorages[0])
            
        } catch {
            fatalError("Unable to initialize provider.")
        }
    }
}
