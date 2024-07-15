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
        
        private var orderTask: Task<Void, Never>?
        private var pingTask: Task<Void, Never>?
        var webSocketService: OrderWebSocketService?
        
        #if CLIENT
        var totalOfBag: Double {
            orders.reduce(0) { $0 + $1.finalPrice }
        }
        #endif
        
        private func establishWSConnection(with clientID: UUID?, with context: ModelContext) async throws {
            guard let clientID else {
                return await MainActor.run {
                    orders = []
                    viewState = .faliedToLoad
                }
            }
            
            guard let webSocketService else {
                return await MainActor.run {
                    do {
                        try fetchOrders(with: context)
                    } catch {
                        viewState = .faliedToLoad
                    }
                }
            }

            sendPing()
            receiveOrders(with: clientID, and: context)
            try await webSocketService.startConnection(with: clientID)
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
                        showingError(
                            with:"Failed to receive orders",
                            error.localizedDescription,
                            and: self.orders.isEmpty ? context : nil
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
            let cupcake = try findCupcake(with: context, and: orderResult.cupcake)
            
            let newOrder = Order(from: orderResult, and: cupcake)
            context.insert(newOrder)
            try context.save()
            
            await MainActor.run {
                withAnimation(.easeIn) {
                    self.orders.insert(newOrder, at: 0)
                }
            }
        }
        
        private func load(_ ordersResult: [Order.Get], with context: ModelContext) async throws {
            for order in ordersResult {
                let predicate = #Predicate<Order> { savedOrder in
                    savedOrder.id == order.id
                }
                
                let descriptor = FetchDescriptor<Order>(predicate: predicate)
                let orders = try context.fetch(descriptor)
                
                if !orders.isEmpty {
                    for order in orders {
                        context.delete(order)
                    }
                }
                
                let cupcake = try findCupcake(with: context, and: order.cupcake)
                
                let newOrder = Order(from: order, and: cupcake)
                context.insert(newOrder)
            }
            
            try context.save()
            
            try await MainActor.run {
                try fetchOrders(with: context)
            }
        }
        
        func fetchOrders(with context: ModelContext) throws {
            let descriptor = FetchDescriptor<Order>()
            let orders = try context.fetch(descriptor)
            self.orders = orders
            
            if viewState == .loading {
                viewState = .load
            }
        }
        
        private func update(_ updatedOrder: Order.Get, with context: ModelContext) async throws {
            let order = orders.first(where: { $0.id == updatedOrder.id })
            
            guard let order else { throw CacheStoreError.notFound }
            
            guard updatedOrder.status != .delivered else {
                guard let index = orders.firstIndex(of: order) else { throw CacheStoreError.notFound }
                context.delete(order)
                try context.save()
                
                return await MainActor.run {
                    return withAnimation(.easeOut) {
                        orders.remove(at: index)
                    }
                }
            }
            
            try await MainActor.run {
                withAnimation {
                    if updatedOrder.status != order.status {
                        order.status = updatedOrder.status
                    }
                    
                    if updatedOrder.readyForDeliveryTime != order.readyForDeliveryTime {
                        order.readyForDeliveryTime = updatedOrder.readyForDeliveryTime
                    }
                }
                
                try context.save()
            }
        }
        
        #if ADMIN
        func sendUpdatedOrder(for clientID: UUID?, orderID: UUID?, and currentStatus: Status?) {
            Task(priority: .background) {
                do {
                    guard let clientID, let orderID, let currentStatus else { throw APIError.fieldsEmpty }
                    
                    guard let webSocketService else { throw WebSocketConnectionError.noConnection }
                    
                    var newStatus = currentStatus
                    
                    if currentStatus == .ordered {
                        newStatus = .readyForDelivery
                    } else if currentStatus == .readyForDelivery {
                        newStatus = .delivered
                    }
                    
                    let updatedOrder = Order.Update(id: orderID, status: newStatus)
                    let sendMessage: Send = .update(updatedOrder)
                    let message = WebSocketMessage<Send>(for: clientID, with: sendMessage)
                    
                    try await webSocketService.send(message)
                } catch let error {
                    await MainActor.run {
                        showingAlert(with: "Failed to send update", error.localizedDescription)
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
                    guard let context else { return }
                    try fetchOrders(with: context)
                } catch {
                    self.orders = []
                }
            }
            
            alertTitle = title
            
            if let description {
                alertMessage = description
            }
            
            showingAlert = true
            
            if orders.isEmpty {
                viewState = .faliedToLoad
            } else {
                viewState = .load
            }
        }
        
        func connect(with clientID: UUID?, and context: ModelContext) {
            Task {
                do {
                    guard let authorizationValue = try? Authentication.value() else {
                        webSocketService = nil
                        return
                    }
                    
                    webSocketService = .init(with: authorizationValue)
                    
                    try await establishWSConnection(with: clientID, with: context)
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
        
        func reconnect(with clientID: UUID?, and context: ModelContext) {
            if webSocketService != nil {
                disconnect(with: clientID, isServerDisconnected: false)
            }
            
            connect(with: clientID, and: context)
        }
        
        func disconnect(with clientID: UUID?, isServerDisconnected: Bool = true, isInBackground: Bool = false) {
            Task {
                if isInBackground {
                    try await Task.sleep(for: .seconds(300))
                }
                
                guard let webSocketService, let clientID else {
                    showingError(with: "Failed to disconnect from the channel.")
                    return
                }
                
                do {
                    if !isServerDisconnected {
                        let disconnectMessage = WebSocketMessage<Send>(for: clientID, with: .disconnect)
                        try await webSocketService.send(disconnectMessage)
                    }
                    try await webSocketService.disconnect()
                    self.orderTask?.cancel()
                    self.orderTask = nil
                    self.pingTask?.cancel()
                    self.pingTask = nil
                    self.webSocketService = nil
                } catch {
                    await MainActor.run {
                        showingError(with: "Failed to disconnect from the channel.", error.localizedDescription)
                    }
                }
            }
        }
        
        func deleteAllOrders(with context: ModelContext) {
            do {
                let descriptor = FetchDescriptor<Order>()
                
                let orders = try context.fetch(descriptor)
                
                for order in orders {
                    context.delete(order)
                }
                
                self.orders = []
            } catch {
                showingError(with: "Failed to delete orders", error.localizedDescription)
            }
        }
        
        deinit {
            print("BagView+ViewModel was deinitialized.")
        }
    }
}
