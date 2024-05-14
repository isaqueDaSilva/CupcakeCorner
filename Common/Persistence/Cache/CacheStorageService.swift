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
    
    func save() throws {
        try context.save()
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
        
        storage[0].cupcakes.append(contentsOf: newCupcakes)
        
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
    
    func updateOrAddSingleNewCupcake(_ cupcake: Cupcake.Get) throws {
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
    
    func deleteUser(_ user: User.Get) throws {
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
            
            let storagesSaved = try get()
            
            _storage = Published(initialValue: storagesSaved)
            
        } catch {
            fatalError("Unable to initialize provider.")
        }
    }
}
