//
//  BagView+ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 23/04/24.
//

import Foundation
import SwiftData
import SwiftUI
import WebSocketHandler

extension BagView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var orders = [Order]()
        @Published var viewState: ViewState = .loading
        @Published var showingAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        private var userID: UUID?
        private let inMemoryOnly: Bool
        
        var orderedOrder: [Order] {
            let ordereds = orders.filter { $0.status == .ordered }
            
            return ordereds.sorted(by: { $0.orderTime < $1.orderTime} )
        }
        
        var readyForDeliveryOrder: [Order] {
            let ordersReadyForDelivery = orders.filter { $0.status == .readyForDelivery}
            return ordersReadyForDelivery.sorted { lhsOrder, rhsOrder in
                guard let lhsTime = lhsOrder.readyForDeliveryTime,
                      let rhsTime = rhsOrder.readyForDeliveryTime
                else { return false }
                
                return lhsTime < rhsTime
            }
        }
        
        private var orderTask: Task<Void, Never>?
        private var pingTask: Task<Void, Never>?
        var webSocketService: OrderWebSocketService?
        
        #if CLIENT
        var totalOfBag: Double {
            orders.reduce(0) { $0 + $1.finalPrice }
        }
        #endif
        
        func connect(with clientID: UUID?, and context: ModelContext) {
            Task {
                do {
                    
                    guard !inMemoryOnly else {
                        return try await MainActor.run {
                            try fetchOrders(with: context)
                        }
                    }
                    
                    guard let clientID, webSocketService == nil else {
                        return await MainActor.run {
                            showingError(with: "You are not connected.")
                        }
                    }
                    
                    self.userID = clientID
                    
                    guard let authorizationValue = try? Authentication.value() else {
                        webSocketService = nil
                        return
                    }
                    
                    webSocketService = .init(with: authorizationValue)
                    
                    try await establishWSConnection(with: context)
                } catch {
                    await MainActor.run {
                        showingError(
                            with: "Failed to get orders",
                            error.localizedDescription,
                            and: context
                        )
                    }
                }
            }
        }
        
        private func establishWSConnection(with context: ModelContext) async throws {
            guard let userID else {
                return await MainActor.run {
                    viewState = .faliedToLoad
                }
            }
            
            guard let webSocketService else {
                return await MainActor.run {
                    do {
                        try fetchOrders(with: context)
                    } catch {
                        viewState = .faliedToLoad
                        print(error.localizedDescription)
                    }
                }
            }

            sendPing()
            receiveOrders(with: userID, and: context)
            try await webSocketService.startConnection(with: userID)
        }
        
        private func sendPing() {
            guard let webSocketService else { return }
            
            pingTask = Task {
                do {
                    try? await Task.sleep(for: .seconds(15))
                    try await webSocketService.sendPing()
                    sendPing()
                } catch {
                    pingTask?.cancel()
                    pingTask = nil
                }
            }
        }
        
        func disconnect(
            isServerDisconnected: Bool = true,
            isInBackground: Bool = false,
            tryToReconnect: (() -> Void)? = nil
        ) {
            Task {
                if isInBackground {
                    try await Task.sleep(for: .seconds(300))
                }
                
                guard let webSocketService, let userID else {
                    showingError(with: "Failed to disconnect from the channel.")
                    return
                }
                
                do {
                    if !isServerDisconnected {
                        let disconnectMessage = WebSocketMessage<Send>(for: userID, with: .disconnect)
                        try await webSocketService.send(disconnectMessage)
                    }
                    try await webSocketService.disconnect()
                    self.orderTask?.cancel()
                    self.orderTask = nil
                    self.pingTask?.cancel()
                    self.pingTask = nil
                    self.webSocketService = nil
                    
                    if isInBackground {
                        self.userID = nil
                    }
                    
                    if let tryToReconnect {
                        tryToReconnect()
                    }
                    
                } catch {
                    await MainActor.run {
                        showingError(with: "Failed to disconnect from the channel.", error.localizedDescription)
                    }
                }
            }
        }
        
        func reconnect(with clientID: UUID?, and context: ModelContext) {
            viewState = .loading
            
            if webSocketService != nil {
                disconnect(isServerDisconnected: false) { [weak self] in
                    guard let self else { return }
                    self.connect(with: clientID, and: context)
                }
            } else {
                connect(with: clientID, and: context)
            }
        }
        
        private func receiveOrders(with clientID: UUID, and context: ModelContext) {
            orderTask = Task {
                do {
                    guard let webSocketService else { throw WebSocketConnectionError.noConnection }
                    
                    for try await message in webSocketService.orderReceivedSubject.values {
                        switch message {
                        case .newOrder(let order):
                            try await insertNew(order, with: context)
                        case .orders(let orders):
                            try await load(orders, with: context)
                        case .update(let updatedOrder):
                            try await update(updatedOrder, with: context)
                        }
                    }
                } catch {
                    await MainActor.run {
                        let isOrderListEmpty = orders.isEmpty
                        showingError(
                            with:"Failed to receive orders",
                            error.localizedDescription,
                            and: isOrderListEmpty ? context : nil
                        )
                    }
                }
            }
        }
        
        private func findCupcake(with context: ModelContext, and cupcakeID: UUID) throws -> Cupcake {
            let predicate = #Predicate<Cupcake> { cupcakeSaved in
                cupcakeSaved.id == cupcakeID
            }
            
            let descriptor = FetchDescriptor<Cupcake>(predicate: predicate)
            let cupcakes = try context.fetch(descriptor)
            
            guard (!cupcakes.isEmpty) && (cupcakes.count == 1) else { throw CacheStoreError.notFound }
            
            return cupcakes[0]
        }
        
        private func insertNew(_ orderResult: Order.Get, with context: ModelContext) async throws {
            do {
                let cupcake = try findCupcake(with: context, and: orderResult.cupcake)
                
                let newOrder = Order(from: orderResult, and: cupcake)
                context.insert(newOrder)
                try context.save()
                
                await MainActor.run {
                    withAnimation(.easeIn) {
                        self.orders.insert(newOrder, at: 0)
                    }
                }
            } catch {
                throw CacheStoreError.inseringError
            }
        }
        
        private func load(_ ordersResult: [Order.Get], with context: ModelContext) async throws {
            do {
                if !ordersResult.isEmpty {
                    for order in ordersResult {
                        let predicate = #Predicate<Order> { savedOrder in
                            savedOrder.id == order.id
                        }
                        
                        let descriptor = FetchDescriptor<Order>(predicate: predicate)
                        let orders = try context.fetch(descriptor)
                        
                        guard (!orders.isEmpty) && (orders.count == 1) && (orders[0].isEqual(to: order)) else {
                            switch orders.isEmpty {
                            case true:
                                let cupcake = try findCupcake(with: context, and: order.cupcake)
                                let newOrder = Order(from: order, and: cupcake)
                                context.insert(newOrder)
                            case false:
                                if orders.count == 1 && !orders[0].isEqual(to: order) {
                                    orders[0].update(from: order)
                                } else if orders.count > 1 {
                                    for order in orders {
                                        context.delete(order)
                                    }
                                    let cupcake = try findCupcake(with: context, and: order.cupcake)
                                    let newOrder = Order(from: order, and: cupcake)
                                    context.insert(newOrder)
                                }
                            }
                            continue
                        }
                    }
                    if context.hasChanges {
                        try context.save()
                    }
                }
                
                try await MainActor.run {
                    try fetchOrders(with: context)
                }
            } catch {
                throw CacheStoreError.loadingFailed
            }
        }
        
        func fetchOrders(with context: ModelContext) throws {
            let descriptor = FetchDescriptor<Order>()
            
            guard let orders = try? context.fetch(descriptor) else {
                throw CacheStoreError.fetchActionFailed
            }
            
            self.orders = orders
            
            if viewState == .loading {
                viewState = .load
            }
        }
        
        private func update(_ updatedOrder: Order.Get, with context: ModelContext) async throws {
            do {
                let order = orders.first(where: { $0.id == updatedOrder.id })
                
                guard let order else { throw CacheStoreError.notFound }
                
                guard updatedOrder.status != .delivered else {
                    guard let index = orders.firstIndex(of: order) else { throw CacheStoreError.notFound }
                    context.delete(order)
                    try context.save()
                    
                    return await MainActor.run {
                        return withAnimation(.smooth(duration: 0.5)) {
                            orders.remove(at: index)
                        }
                    }
                }
                
                try await MainActor.run {
                    withAnimation(.easeIn) {
                        order.update(from: updatedOrder)
                    }
                    
                    try context.save()
                }
            } catch {
                throw CacheStoreError.updateFailed
            }
        }
        
        #if ADMIN
        func sendUpdatedOrder(with orderID: UUID?, and currentStatus: Status) {
            Task(priority: .background) {
                do {
                    guard let userID, let orderID else { throw APIError.fieldsEmpty }
                    
                    guard let webSocketService else { throw WebSocketConnectionError.noConnection }
                    
                    var newStatus = currentStatus
                    
                    if currentStatus == .ordered {
                        newStatus = .readyForDelivery
                    } else if currentStatus == .readyForDelivery {
                        newStatus = .delivered
                    }
                    
                    let updatedOrder = Order.Update(id: orderID, status: newStatus)
                    let sendMessage: Send = .update(updatedOrder)
                    let message = WebSocketMessage<Send>(for: userID, with: sendMessage)
                    
                    try await webSocketService.send(message)
                } catch let error {
                    await MainActor.run {
                        showingError(with: "Failed to send update", error.localizedDescription)
                    }
                }
            }
        }
        #endif
        
        private func showingError(
            with title: String,
            _ description: String? = nil,
            and context: ModelContext? = nil
        ) {
            if orders.isEmpty {
                do {
                    if let context {
                        try fetchOrders(with: context)
                    }
                } catch {
                    self.orders = []
                }
            }
            
            alertTitle = title
            
            if let description {
                alertMessage = description
            }
            
            showingAlert = true
            
            if orders.isEmpty && userID != nil {
                viewState = .faliedToLoad
            } else {
                viewState = .load
            }
        }
        
        func deleteAllOrders(with context: ModelContext) {
            do {
                for order in orders {
                    context.delete(order)
                }
                
                try context.save()
                
                self.orders = []
            } catch {
                showingError(with: "Failed to delete orders", CacheStoreError.deleteError.localizedDescription)
            }
        }
        
        init(inMemoryOnly: Bool = false) {
            self.inMemoryOnly = inMemoryOnly
        }
        
        deinit {
            print("BagView+ViewModel was deinitialized.")
        }
    }
}
