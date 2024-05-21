//
//  BagViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 23/04/24.
//

import Foundation
import SwiftUI

extension BagView {
    final class ViewModel: ObservableObject {
        @Published var orders = [Order.Get]()
        @Published var viewState: ViewState = .loading
        @Published var showingAlert = false
        @Published var alert: AppErrorProtocol?
        
        private var receiveMessageTask: Task<Void, Never>? = nil
        private let orderService = OrderWebSocketService()
        private var clientID: UUID?
        
        var totalOfTheBag: Double {
            var total: Double = 0
            
            orders.forEach { order in
                total += order.finalPrice
            }
            
            return total
        }
        
        func getImage(from data: Data) -> Image {
            let uiImage = UIImage(data: data)
            
            guard let uiImage else {
                return Icon.questionmarkDiamond.systemImage
            }
            
            return Image(uiImage: uiImage)
        }
        
        private func showingAlert(
            error: Error
        ) {
            alert = error as? AppErrorProtocol
            disconnect()
            viewState = .faliedToLoad
            showingAlert = true
        }
        
        func setClientID(clientID: UUID?) {
            self.clientID = clientID
        }
        
        private func getOrders() throws {
            guard let clientID else {
                orders = []
                viewState = .load
                return
            }
            
            Task {
                do {
                    let message = WebSocketMessage<Send>(clientID: clientID, data: .get)
                    try await orderService.send(message)
                } catch let error {
                    showingAlert(error: error)
                }
            }
        }
        
        func connect() {
            do {
                try orderService.connect()
                
                try getOrders()
                receiveValues()
                
            } catch let error {
                orders = []
                viewState = .faliedToLoad
                showingAlert(error: error)
            }
        }
        
        private func receiveValues()  {
            receiveMessageTask = Task {
                do {
                    for try await receivedMessage in orderService.orderReceivedSubject.values {
                        switch receivedMessage.data {
                        case .newOrder(let order):
                            await MainActor.run {
                                insertNew(order)
                            }
                        case .orders(let orders):
                            await MainActor.run {
                                load(orders)
                            }
                        case .update(let order):
                            await MainActor.run {
                                update(order)
                            }
                        }
                    }
                } catch {
                    await MainActor.run {
                        showingAlert(error: error)
                    }
                }
            }
        }
        
        private func insertNew(_ newOrder: Order.Get) {
            withAnimation(.easeIn) {
                orders.append(newOrder)
            }
        }
        
        private func load(_ orders: [Order.Get]) {
            self.orders = orders
            viewState = .load
        }
        
        private func update(_ updatedOrder: Order.Get) {
            for order in orders {
                if order.id == updatedOrder.id {
                    guard let index = orders.firstIndex(of: order) else { return }
                    
                    self.orders.remove(at: index)
                    if updatedOrder.status != .delivered {
                        orders.insert(updatedOrder, at: index)
                    }
                }
            }
        }
        
        func disconnect() {
            orderService.disconnect()
            receiveMessageTask?.cancel()
            receiveMessageTask = nil
        }
        
        #if ADMIN
        func updateOrder(with id: UUID, status: Status) {
            Task {
                do {
                    let updatedOrder = Order.Update(id: id, status: status)
                    let sendMessage: Send = .update(updatedOrder)
                    
                    if let clientID {
                        let message = WebSocketMessage<Send>(clientID: clientID, data: sendMessage)
                        try await orderService.send(message)
                    }
                } catch let error {
                    showingAlert(error: error)
                }
            }
        }
        #endif
        
        func displayName(_ order: Order.Get) -> String {
            #if CLIENT
            return order.cupcake.flavor
            #elseif ADMIN
            return order.userName
            #endif
        }
        
        func displayDescription(_ order: Order.Get) -> String {
            #if CLIENT
            let text = """
            Quantity: \(order.quantity)
            Add Sprinkles: \(order.addSprinkles ? "Yes" : "No")
            Extra Frosting: \(order.extraFrosting ? "Yes" : "No")
            Status: \(order.status.displayedName)
            """
            return text
            #elseif ADMIN
            let text = """
            \(order.cupcake.flavor),
            Quantity: \(order.quantity)
            Add Sprinkles: \(order.addSprinkles ? "Yes" : "No")
            Extra Frosting: \(order.extraFrosting ? "Yes" : "No")
            Status: \(order.status.displayedName)
            """
            
            return text
            #endif
        }
    }
}
