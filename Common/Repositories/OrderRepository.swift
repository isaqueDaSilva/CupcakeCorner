//
//  OrderRepository.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class OrderRepository: ObservableObject {
    @Published var orders = [UUID: Order]()
    @Published var filteredOrderStatus: Status = .ordered
    
    var filteredOrder: [Order] {
        switch filteredOrderStatus {
        case .ordered:
            orderedOrder
        case .readyForDelivery:
            readyForDeliveryOrder
        case .delivered:
            deliveredOrders
        }
    }
    
    private let storageManager: StorageManager
    
    private var orderedOrder: [Order] {
        let orders = self.orders.values.filter({$0.status == .ordered})
        
        return orders.sorted(by: { $0.orderTime > $1.orderTime})
    }
    private var readyForDeliveryOrder: [Order] {
        let orders = self.orders.values.filter({$0.status == .readyForDelivery})
        
        return orders.sorted(by: { ($0.readyForDeliveryTime ?? .now) > ($1.readyForDeliveryTime ?? .now) })
    }
    
    private var deliveredOrders: [Order] {
        let orders = self.orders.values.filter({$0.status == .delivered})
        
        return orders.sorted(by: { ($0.deliveredTime ?? .now) > ($1.deliveredTime ?? .now) })
    }
    
    #if CLIENT
    var totalOfBag: Double {
        let ordersFiltered = orderedOrder + readyForDeliveryOrder
        return ordersFiltered.reduce(0) { $0 + $1.finalPrice }
    }
    #endif
    
    func load() async throws {
        let ordersFetched = try await storageManager.find(Order.self)
        
        var orders = [UUID: Order]()
        
        for order in ordersFetched {
            orders.updateValue(order, forKey: order.id)
        }
        
        await MainActor.run {
            self.orders = orders
        }
    }
    
    func load(with orderResults: [Order.Get]) async throws {
        let ordersSaved = orders.map({ $0.value })
        let existingOrders = try await storageManager.load(with: ordersSaved, and: orderResults)
        
        var orders = [UUID: Order]()
        
        for order in existingOrders {
            if order.cupcake == nil {
                let cupcakeResult = orderResults.first(where: { $0.id == order.id })
                
                if let cupcakeID = cupcakeResult?.cupcake {
                    let predicate = #Predicate<Cupcake> { cupcake in
                        cupcake.id == cupcakeID
                    }
                    
                    let cupcakes = try await storageManager.find(Cupcake.self, with: predicate)
                    
                    guard !cupcakes.isEmpty && cupcakes.count == 1,
                          let cupcake = cupcakes.first
                    else {
                        throw RepositoryError.noItem
                    }
                    
                    let orderUpdated = try order.addCupcake(cupcake)
                    
                    try orderUpdated.modelContext?.save()
                    
                    orders.updateValue(orderUpdated, forKey: orderUpdated.id)
                }
            } else {
                orders.updateValue(order, forKey: order.id)
            }
        }
        
        await MainActor.run {
            self.orders = orders
        }
    }
    
    func insert(_ orderResult: Order.Get, and cupcake: Cupcake?) async throws {
        let order = try await storageManager.insert(new: orderResult, as: Order.self)
        
        do {
            let orderWithCupcake = try order.addCupcake(cupcake)
            
            await MainActor.run {
                _ = self.orders.updateValue(orderWithCupcake, forKey: order.id)
            }
        } catch {
            throw RepositoryError.invalidInsertion
        }
    }
    
    func update(with orderResult: Order.Get) async throws {
        guard let order = orders[orderResult.id] else {
            throw RepositoryError.noItem
        }
        
        let updatedOrder = order.update(from: orderResult)
        
        try updatedOrder.modelContext?.save()
        
        await MainActor.run {
            _ = self.orders.updateValue(updatedOrder, forKey: updatedOrder.id)
        }
    }
    
    func delete(by id: UUID) async throws {
        let order = orders[id]
        
        guard let order else {
            throw RepositoryError.noItem
        }
        
        try await storageManager.remove(order)
        
        await MainActor.run {
            _ = self.orders.removeValue(forKey: id)
        }
    }
    
    func deleteAll() async throws {
        try await storageManager.removeAll(Order.self)
        
        await MainActor.run {
            self.orders.removeAll()
        }
    }
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    deinit {
        print("OrderRepository was deinitialized.")
    }
}
