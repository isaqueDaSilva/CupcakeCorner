//
//  BagViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 23/04/24.
//

import Foundation
import SwiftUI

extension BagView {
    /// An object that discrible how the BagView handle with some actions.
    final class ViewModel: ObservableObject {
        /// Stores the all orders avaiable for displaying
        @Published var orders = [Order.Get]()
        
        /// Stores the current view state value for indicates
        /// if the page is loading or load.
        @Published var viewState: ViewState = .loading
        
        /// Stores the value for indicates if some error is displaying or not.
        @Published var showingAlert = false
        @Published var alert: AppAlert?
        
        /// Stores the cache store instance.
        private var cacheStore: CacheStoreService
        
        /// Stores an Task instance to be indicates
        /// if the "receiveMessage" method is able to execute your task.
        private var receiveMessageTask: Task<Void, Never>? = nil
        
        /// Stores the instance of the OrderWebSocketService
        /// for connect, receive and send message for the WS channel
        private let orderService = OrderWebSocketService()
        
        /// Stores the id of the client for performing some actions.
        private var clientID: UUID?
        
        /// Gets the current total of the bag.
        var totalOfTheBag: Double {
            var total: Double = 0
            
            orders.forEach { order in
                total += order.finalPrice
            }
            
            return total
        }
        
        
        /// Creating an Image from the data gets from the Order model.
        /// - Parameter data: The data representation of an Image.
        /// - Returns: Returns an image representation.
        func getImage(from data: Data) -> Image {
            let uiImage = UIImage(data: data)
            
            guard let uiImage else {
                return Icon.questionmarkDiamond.systemImage
            }
            
            return Image(uiImage: uiImage)
        }
        
        /// Displaying an error when some task throwing an error.
        /// - Parameter error: The error issued from the task.
        private func showingError(_ error: Error) {
            alert = AppAlert(
                title: "Falied to get orders.",
                description: error.localizedDescription
            )
            viewState = .faliedToLoad
            showingAlert = true
        }
        
        /// Geting an user id from the cache storage.
        func getClientID() {
            Task {
                do {
                    // Fetch the user saved on the Core Data.
                    let user = try await cacheStore.fetchWithRequest(for: User.self, with: "User")
                    
                    // Checks if the store is no empty.
                    guard !user.isEmpty else {
                        clientID = nil
                        return
                    }
                    
                    // Sets an value for the "clientID" property.
                    clientID = user[0].id
                } catch {
                    clientID = nil
                }
            }
        }
        
        /// Send an request for the channel for getting all orders.
        private func getOrders() {
            // Checks if the clientID property
            // is not empty.
            guard let clientID else {
                orders = []
                viewState = .load
                return
            }
            
            Task {
                do {
                    // Defines a new instance of the WebSocketMessage
                    // and send for the channel.
                    let message = WebSocketMessage<Send>(clientID: clientID, data: .get)
                    try await orderService.send(message)
                } catch let error {
                    // If some error occur,
                    // the showing error is displayed.
                    await MainActor.run {
                        showingError(error)
                    }
                }
            }
        }
        
        /// Connecting on the WebSocket channel.
        private func connect() {
            do {
                // Makes the connection.
                try orderService.connect()
                
                // Obtain orders
                getOrders()
                
                // Calls the receiverValues method
                // to subscribe to the
                // "orderReceivedSubject" publisher
                // and observes the values that will be emitted.
                receiveValues()
                
            } catch let error {
                // If some error will be occur
                // will be set the orders as empty state
                orders = []
                
                // After will be set the "faliedToLoad" state
                viewState = .faliedToLoad
                
                // And finally showing the error.
                showingError(error)
            }
        }
        
        /// Receiving the values gets from the channel.
        private func receiveValues()  {
            receiveMessageTask = Task {
                do {
                    // Sets an loop into values emmited from the publisher.
                    for try await receivedMessage in orderService.orderReceivedSubject.values {
                        // Pass an switcher into received message
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
                    // If some error occur,
                    // the showing error is displayed.
                    await MainActor.run {
                        showingError(error)
                    }
                }
            }
        }
        
        /// Inserting a new item into orders property.
        /// - Parameter newOrder: New order received.
        private func insertNew(_ newOrder: Order.Get) {
            withAnimation(.easeIn) {
                orders.append(newOrder)
            }
        }
        
        /// Loading the all orders received from the channel.
        /// - Parameter orders: The orders received.
        private func load(_ orders: [Order.Get]) {
            // Inserting into orders property.
            self.orders = orders
            viewState = .load
        }
        
        /// Updating an existing order.
        /// - Parameter updatedOrder: An updated order received
        private func update(_ updatedOrder: Order.Get) {
            // Pass an loop into existing orders
            for order in orders {
                // Checks what order matches with the updated order.
                if order.id == updatedOrder.id {
                    guard let index = orders.firstIndex(of: order) else { return }
                    
                    // Remove from the array
                    self.orders.remove(at: index)
                    
                    // If the status is equal to delivered
                    // inserts the order updated in the same index
                    // order removed.
                    if updatedOrder.status != .delivered {
                        orders.insert(updatedOrder, at: index)
                    }
                }
            }
        }
        
        /// Disconnecting the channel
        func disconnect() {
            // Performing the disconnect action.
            orderService.disconnect()
            
            // Cancels the task
            // and sets the property as nil
            receiveMessageTask?.cancel()
            receiveMessageTask = nil
        }
        
        #if ADMIN
        /// Sending an update order in the channel.
        /// - Parameters:
        ///   - id: The id of the order.
        ///   - status: The updated status that will be updating into database.
        func updateOrder(for orderID: UUID, with currentStatus: Status) {
            Task {
                do {
                    var newStatus = currentStatus
                    
                    if currentStatus == .ordered {
                        newStatus = .outForDelivery
                    } else if currentStatus == .outForDelivery {
                        newStatus = .delivered
                    }
                    
                    // Creates a Update order
                    let updatedOrder = Order.Update(id: orderID, status: newStatus)
                    
                    // Creates a new Send instance, with the "update" case
                    let sendMessage: Send = .update(updatedOrder)
                    
                    // Checks if the clientID is not nil
                    if let clientID {
                        // Creates a new WebSocketMessage with the send value and the clientID
                        let message = WebSocketMessage<Send>(clientID: clientID, data: sendMessage)
                        
                        // Sends the updated order into channel.
                        try await orderService.send(message)
                    }
                } catch let error {
                    // If an error occur
                    // will be displayed an error.
                    showingError(error)
                }
            }
        }
        #endif
        
        /// Displays a name for display into the title of the ItemCard View
        func displayName(_ order: Order.Get) -> String {
            #if CLIENT
            return order.cupcake.flavor
            #elseif ADMIN
            return order.userName
            #endif
        }
        
        /// Displays an description for display into the description of the ItemCard View
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
        
        init(inMemoryOnly: Bool = false) {
            self.cacheStore = inMemoryOnly ? .sharedInMemoryOnly : .shared
            
            getClientID()
            
            connect()
        }
    }
}
