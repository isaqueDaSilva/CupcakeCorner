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
    
    /// Find all instances of the ``DataModel`` saved in Persistence Store.
    /// - Parameters:
    ///   - model: Type of model that will be sought.
    ///   - predicate: Specific coordinations to find a specific instance.
    ///   - sortedBy: Specific sorting description to organize the results and given back to top level as expected.
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
    
    /// Compare results from API call with the stored instances
    ///
    /// When we given some result from API, those will be compared with the saved instances, flowing this steps:
    /// - The API's result is the source of truth, so because this we check if has some instance with the same ID saved.
    /// - If yes, we make an update in the instance to garantie that is stays always syncronized with the instance saved on database.
    /// - If not exist, a new instance will be created.
    /// - Finaly if some instance only exist on persistence storage, it's will be deleted.
    ///
    /// - Parameters:
    ///   - savedModels: All saved persistence models.
    ///   - modelsResult: All API's call result.
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
    
    /// Gets, compare, find and load instances saved on persistence store and give back to app's top level modules.
    /// - Parameters:
    ///   - savedModels: All saved persistence models.
    ///   - predicate: Specific coordinations to find a specific instance.
    ///   - sortedBy: Specific sorting description to organize the results and given back to top level as expected.
    ///   - results: All API's call result models.
    func load<T: DataModel, R: DataResponse>(
        with savedModels: [T],
        _ predicate: Predicate<T>? = nil,
        _ sortedBy: [SortDescriptor<T>] = [],
        and results: [R]
    ) throws(StorageManagerError) -> [T] {
        if savedModels.isEmpty {
            let models = try find(T.self, with: predicate, and: sortedBy)
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
    
    /// Insert a new instance into a persistence store based on API's result model.
    /// - Parameters:
    ///   - modelResult: An API's call result model.
    ///   - modelType: The type of persistence model that will be want to save.
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
    
    /// Removes an specific instance from persistence store.
    /// - Parameter model: The model's instance that we want to delete.
    func remove<T: DataModel>(
        _ model: T
    ) throws(StorageManagerError) {
        modelContext.delete(model)
        try save()
    }
    
    /// Remove all instances of specific Persistence Model saved.
    /// - Parameters:
    ///   - modelType: The type of persistence model that will be want to save.
    ///   - isincludeSubclasses: Indicates if we want delete relationships as well when we deleting a main model.
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

    #if DEBUG
    /// Creates a StorageManager instance to use in Xcode Previews.
    /// - Parameter isInsertingData: Indicates if we insert dummy datas when the instance is created.
    /// - Returns: Returns a new instance of ``StorageManagerError``.
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
    #endif
    
    init(with container: ModelContainer) {
        self.modelContainer = container
        
        let context = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    deinit {
        print("BackgroundSerialPersistenceActor deinitialized.")
    }
}
