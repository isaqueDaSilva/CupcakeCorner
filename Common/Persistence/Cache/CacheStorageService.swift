//
//  CacheStorageService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation
import SwiftData

final class CacheStorageService: ObservableObject {
    @Published var storage: [CacheStorage] = []
    
    private let context: ModelContext
    
    #if CLIENT
    var newestCupcake: Cupcake.Get? {
        storage[0].cupcakes.min { $0.createdAt > $1.createdAt }
    }
    #endif
    
    func save() throws {
        try context.save()
        storage = try get()
    }
    
    private func create(new storage: CacheStorage) throws {
        context.insert(storage)
        try save()
    }
    
    func addNewUser(_ newUser: User.Get) throws {
        self.storage[0].user = newUser
        try save()
    }
    
    func addNewCupcakes(_ newCupcakes: [Cupcake.Get]) throws {
        if !storage[0].cupcakes.isEmpty {
            storage[0].cupcakes.removeAll()
        }
        
        storage[0].cupcakes = newCupcakes
        
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
    
    func addNewCupcake(_ cupcake: Cupcake.Get) throws {
        guard storage[0].cupcakes.first(where: { $0.flavor == cupcake.flavor }) == nil else {
            throw PersistenceDataError.duplicateItem
        }
        
        storage[0].cupcakes.append(cupcake)
        
        try save()
    }
    
    func updateCupcake(_ cupcake: Cupcake.Get) throws {
        guard storage[0].cupcakes.isEmpty else {
            guard let index = storage[0].cupcakes.firstIndex(of: cupcake) else {
                throw PersistenceDataError.notFound
            }
            
            storage[0].cupcakes.remove(at: index)
            storage[0].cupcakes.insert(cupcake, at: index)
            
            return
        }
        
        storage[0].cupcakes.append(cupcake)
        
        try save()
    }
    
    func deleteUser() throws {
        storage[0].user = nil
        try save()
    }
    
    func deleteCupcake(_ cupcake: Cupcake.Get) throws {
        guard let index = storage[0].cupcakes.firstIndex(of: cupcake) else {
            throw PersistenceDataError.notFound
        }
        
        storage[0].cupcakes.remove(at: index)
        
        try save()
    }
    
    init(inMemoryOnly: Bool = false) {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: inMemoryOnly)
            let container = try ModelContainer(for: CacheStorage.self, configurations: config)
            self.context = ModelContext(container)
            
            let descriptor = FetchDescriptor<CacheStorage>()
            let gettedStorage = try context.fetch(descriptor)
            
            // Checks if has some storage model saved
            // and in case has, the count is equal to 1.
            guard !gettedStorage.isEmpty, gettedStorage.count == 1 else {
                // Delete all storages saved
                // in case the storages model count is greater than 1
                for storage in gettedStorage {
                    context.delete(storage)
                }
                
                // Save changes
                try context.save()
                
                // Create a new storage
                let storage = CacheStorage()
                context.insert(storage)
                try context.save()
                
                // Get the storage saved and initialize the storage property
                let gettedNewStorage = try context.fetch(descriptor)
                _storage = Published(initialValue: gettedNewStorage)
                return
            }
            
            _storage = Published(initialValue: gettedStorage)
            
        } catch {
            fatalError("Unable to initialize provider.")
        }
    }
}
