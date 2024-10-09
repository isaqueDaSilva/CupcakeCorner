//
//  StorageManager.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation
import SwiftData

/// Default executor to perform actions on persistence store with background threads.
final actor StorageManager: ModelActor {
    /// A Default model container that manage the persistence store.
    let modelContainer: ModelContainer
    
    /// A default executor of internal and isolated tasks.
    let modelExecutor: any ModelExecutor
    
    /// A standard model context that coordinates changes to model container.
    private var modelContext: ModelContext {
        modelExecutor.modelContext
    }
    
    /// Save model's change.
    private func save() throws(StorageManagerError) {
        do {
            try modelContext.save()
        } catch {
            throw .saveFailed
        }
    }
    
    func find<T: DataModel>(
        _ model: T.Type,
        with predicate: Predicate<T>? = nil,
        and sortedBy: [SortDescriptor<T>] = []
    ) throws(StorageManagerError) -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortedBy)
        
        guard let models = try? modelContext.fetch(descriptor) else {
            throw .fetchFailed
        }
        
        return models
    }
    
    private func checkIfModelsExist<T: DataModel, R: DataResponse>(
        in savedModels: [T],
        with modelsResult: [R]
    ) throws(StorageManagerError) -> [T] {
        var models = [T]()
        var modelsResultRest = modelsResult
        
        for model in modelsResult {
            if (savedModels.first(where: { $0.id == model.id}) == nil) {
                let newModel = try insert(new: model, as: T.self)
                models.append(newModel)
                
                modelsResultRest.removeAll(where: { $0.id == model.id } )
            }
        }
        
        guard !modelsResultRest.isEmpty else {
            return models
        }
        
        for model in savedModels {
            if let modelResult = (modelsResult.first(where: { $0.id == model.id })) {
                guard let modelGetted = modelResult as? T.Result else { throw .unknownModelType }
                
                let modelUpdated = model.update(from: modelGetted)
                
                do {
                    try modelUpdated.modelContext?.save()
                } catch {
                    throw .saveFailed
                }
                
                models.append(modelUpdated)
            } else {
                try remove(model)
            }
        }
        
        return models
    }
    
    func load<T: DataModel, R: DataResponse>(
        with savedModels: [T],
        _ predicate: Predicate<T>? = nil,
        _ sortedBy: [SortDescriptor<T>] = [],
        and results: [R]
    ) throws(StorageManagerError) -> [T] {
        if savedModels.isEmpty {
            let models = try find(T.self, with: predicate, and: sortedBy)
            print(models.count)
            if models.isEmpty {
                var models = [T]()
                
                for result in results {
                    let model = try insert(new: result, as: T.self)
                    models.append(model)
                }
                
                return models
            } else {
                let existingModels = try checkIfModelsExist(in: models, with: results)
                return existingModels
            }
        } else {
            let existingModels = try checkIfModelsExist(in: savedModels, with: results)
            return existingModels
        }
    }

    func insert<T: DataModel, R: Codable>(
        new modelResult: R,
        as modelType: T.Type
    ) throws(StorageManagerError) -> T {
        guard let fetchedResult = modelResult as? T.Result else {
            throw .insertFailed
        }
        
        let model = modelType.create(from: fetchedResult)
        modelContext.insert(model)
        try save()
        
        return model
    }
    
    func remove<T: DataModel>(
        _ model: T
    ) throws(StorageManagerError) {
        modelContext.delete(model)
        try save()
    }
   
    func removeAll<T: DataModel>(
        _ modelType: T.Type,
        isincludeSubclasses: Bool = false
    ) throws(StorageManagerError) {
        do {
            try modelContext.delete(model: modelType, includeSubclasses: isincludeSubclasses)
        } catch {
            throw .deleteFail
        }
        
        try save()
    }

    nonisolated static func preview(isInsertingData: Bool = true) -> StorageManager {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: Cupcake.self, Order.self, User.self,
                configurations: config
            )
            
            let modelContext = ModelContext(container)
            
            if isInsertingData {
                try Cupcake.makeSampleCupcakes(in: modelContext)
                try Order.makeSampleOrders(in: modelContext)
                try User.makeSampleUser(in: modelContext)
            }
            
            let manager = StorageManager(with: container)
            
            return manager
        } catch {
            fatalError("Failed to create a preview storage manager: \(error.localizedDescription).")
        }
    }
    
    init(with container: ModelContainer) {
        self.modelContainer = container
        
        let context = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    deinit {
        print("BackgroundSerialPersistenceActor deinitialized.")
    }
}
