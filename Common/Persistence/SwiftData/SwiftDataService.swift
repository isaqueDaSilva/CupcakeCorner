//
//  SwiftDataService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation
import SwiftData

struct SwiftDataService<M: PersistentModel> {
    private let container: ModelContainer
    private let context: ModelContext
    
    private func save() throws {
        try context.save()
    }
    
    func create(new model: M) throws {
        context.insert(model)
        try save()
    }
    
    func get() throws -> [M] {
        let descriptor = FetchDescriptor<M>()
        
        let models = try context.fetch(descriptor)
        
        return models
    }
    
    func delete(_ model: M) throws {
        context.delete(model)
        try save()
    }
    
    init(inMemoryOnly: Bool = false) {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: inMemoryOnly)
            self.container = try ModelContainer(for: M.self, configurations: config)
            self.context = ModelContext(container)
        } catch {
            fatalError("Unable to initialize provider.")
        }
    }
}
