//
//  BagViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 23/04/24.
//

import Combine
import Foundation
import SwiftUI

extension BagView {
    final class ViewModel: ObservableObject {
        @Published var orders = [Order.Get]()
        @Published var viewState: ViewState = .loading
        @Published var showingAlert = false
        @Published var alert: AppAlert?
        
        private var cancellables = Set<AnyCancellable>()
        private let orderService = OrderWebSocketService()
        private var clientID: UUID?
        
        var totalOfTheBag: Double {
            var total: Double = 0
            
            orders.forEach { order in
                total += order.finalPrice
            }
            
            return total
        }
        
        private func showingAlert(
            title: String,
            error: Error
        ) {
            alert = AppAlert(title: title, description: error.localizedDescription)
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
            
            let message = WebSocketMessage<Send>(clientID: clientID, data: .get)
            try orderService.send(message)
        }
        
        func connect() {
            do {
                try orderService.connect()
                
                try getOrders()
                receiveValues()
                
            } catch let error {
                orders = []
                viewState = .faliedToLoad
                showingAlert(
                    title: "Falied to connect.",
                    error: error
                )
            }
        }
        
        private func getReceive(
            _ message: PassthroughSubject<WebSocketMessage<Receive>, any Error>.Output
        ) -> Receive {
            message.data
        }
        
        private func handleWithError(
            _ error: PassthroughSubject<WebSocketMessage<Receive>, any Error>.Failure
        ) {
            showingAlert(
                title: "Falied to Get Data",
                error: error
            )
        }
        
        private func receiveValues()  {
            orderService.orderReceivedSubject
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .map(getReceive)
                .sink { [weak self] completation in
                    guard let self else { return }
                    switch completation {
                    case .finished:
                        print("Finished with success")
                        break
                    case .failure(let error):
                        self.showingAlert(
                            title: "Falied to Get Orders",
                            error: error
                        )
                        break
                    }
                } receiveValue: { [weak self] message in
                    guard let self else { return }
                    
                    switch message {
                    case .newOrder(let newOrder):
                        self.orders.append(newOrder)
                    case .orders(let orders):
                        self.orders = orders
                        self.viewState = .load
                    case .update(let updatedOrder):
                        for order in orders {
                            if order.id == updatedOrder.id {
                                guard let index = orders.firstIndex(of: order) else { return }
                                
                                self.orders.remove(at: index)
                                if updatedOrder.status != .delivered {
                                    self.orders.insert(updatedOrder, at: index)
                                }
                            }
                        }
                    }
                }
                .store(in: &cancellables)
        }
        
        func disconnect() { orderService.disconnect() }
        
        #if ADMIN
        func updateOrder(with id: UUID, status: Status) {
            do {
                let updatedOrder = Order.Update(id: id, status: status)
                let sendMessage: Send = .update(updatedOrder)
                
                if let clientID {
                    let message = WebSocketMessage<Send>(clientID: clientID, data: sendMessage)
                    try orderService.send(message)
                }
            } catch let error {
                showingAlert(
                    title: "Falied to send Update",
                    error: error
                )
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
