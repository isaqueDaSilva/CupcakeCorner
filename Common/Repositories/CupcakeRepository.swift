//
//  CupcakeRepository.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class CupcakeRepository: ObservableObject {
    @Published var cupcakes = [UUID: Cupcake]() {
        didSet {
            cupcakeList = cupcakes.valuesArray.sorted(by: { $0.createAt > $1.createAt })
            totalSales = cupcakes.valuesArray.reduce(0, { $0 + $1.salesQuantity })
            avarge = totalSales / cupcakes.count
        }
    }
    
    @Published var selectedCupcake: Cupcake?
    @Published var totalSales = 0
    @Published var avarge = 0
    
    var cupcakeList: [Cupcake] = []
    
    #if CLIENT
    var newestCupcake: Cupcake?
    #endif
    
    private let storageManager: StorageManager
    
    func set(_ cupcake: Cupcake?) {
        guard (selectedCupcake == nil && cupcake != nil) || (selectedCupcake != nil && cupcake == nil) else { return }
        
        Task { @MainActor in
            selectedCupcake = cupcake
        }
    }
    
    func load() async throws {
        let cupcakesFetched = try await storageManager.find(Cupcake.self)
        
        var cupcakes = [UUID: Cupcake]()
        
        for cupcake in cupcakesFetched {
            cupcakes.updateValue(cupcake, forKey: cupcake.id)
        }
        
        await MainActor.run {
            self.cupcakes = cupcakes
            #if CLIENT
            newestCupcake = cupcakes.values.min(by: { $0.createAt > $1.createAt })
            #endif
        }
    }
    
    func load(with cupcakesResult: [Cupcake.Get]) async throws {
        let cupcakesSaved = cupcakes.map({ $0.value })
        
        let existingCupcakes = try await storageManager.load(with: cupcakesSaved, and: cupcakesResult)
        
        var cupcakes = [UUID: Cupcake]()
        
        for cupcake in existingCupcakes {
            cupcakes.updateValue(cupcake, forKey: cupcake.id)
        }
        
        await MainActor.run {
            self.cupcakes = cupcakes
            #if CLIENT
            newestCupcake = cupcakes.values.min(by: { $0.createAt > $1.createAt })
            #endif
        }
    }
    
    func findCupcake(by id: UUID?) -> Cupcake? {
        guard let id else { return nil }
        let cupcake = self.cupcakes[id]
        return cupcake
    }
    
    func deleteAll() async throws {
        try await storageManager.removeAll(Cupcake.self)
        
        await MainActor.run {
            cupcakes.removeAll()
        }
    }
    
    
    #if ADMIN
    func insert(_ cupcake: Cupcake.Get) async throws {
        let newCupcake = try await storageManager.insert(new: cupcake, as: Cupcake.self)
        
        await MainActor.run {
            _ = self.cupcakes.updateValue(newCupcake, forKey: newCupcake.id)
        }
    }
    
    func makeUpdateRequest(with updateData: Cupcake.Update) async throws -> Cupcake.Update {
        guard let cupcake = selectedCupcake else {
            throw RepositoryError.noItem
        }
        
        var updatedImageData: Data? {
            if let imageData = updateData.coverImage, imageData != cupcake.coverImage {
                return imageData
            } else {
                return nil
            }
        }
        
        var updatedFlavor: String? {
            if let flavor = updateData.flavor, flavor != cupcake.flavor {
                return flavor
            } else {
                return nil
            }
        }
        
        var updatedIngredients: [String]? {
            if let ingredients = updateData.ingredients, ingredients != cupcake.ingredients {
                return ingredients
            } else {
                return nil
            }
        }
        
        var updatedPrice: Double? {
            if let price = updateData.price, price != cupcake.price {
                return price
            } else {
                return nil
            }
        }
        
        let updatedCupcake = Cupcake.Update(
            coverImage: updatedImageData,
            flavor: updatedFlavor,
            ingredients: updatedIngredients,
            price: updatedPrice
        )
        
        return updatedCupcake
    }
    
    func update(with cupcakeResult: Cupcake.Get) async throws {
        let cupcake = (selectedCupcake != nil && selectedCupcake?.id == cupcakeResult.id) ?
                        selectedCupcake :
                        self.findCupcake(by: cupcakeResult.id)
        
        guard let cupcake else {
            throw RepositoryError.noItem
        }
        
        let updatedCupcake = cupcake.update(from: cupcakeResult)
        try updatedCupcake.modelContext?.save()
        
        await MainActor.run {
            cupcakes[updatedCupcake.id] = updatedCupcake
        }
    }
    
    func delete() async throws {
        guard let selectedCupcake else {
            throw RepositoryError.noItem
        }
        
        try await storageManager.remove(selectedCupcake)
        
        await MainActor.run {
            _ = self.cupcakes.removeValue(forKey: selectedCupcake.id)
        }
    }
    #endif
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    deinit {
        print("UserRepository was deinitialized.")
    }
}
