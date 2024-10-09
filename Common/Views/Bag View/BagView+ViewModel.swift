//
//  ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//


import Foundation
import SwiftData
import SwiftUI

extension BagView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .loading
        @Published var showingAlert = false
        @Published var alert = AlertHandler()
        
        var wsService: OrderWebSocketService?
        
        func connectWS() {
            do {
                let authorizationValue = try TokenGetter.getValue()
                
                wsService = .init(with: authorizationValue)
                
            } catch {
                showError(
                    title: "Failed to connect in the channel",
                    description: error.localizedDescription
                )
            }
        }
        
        func disconnect(
            isInBackground: Bool = false,
            isChannelDisconnected: Bool = false
        ) {
            Task {
                if isInBackground {
                    try? await Task.sleep(for: .seconds(300))
                }
                if let wsService {
                    try await wsService.disconnect(
                        with: .finished,
                        isChannelDisconnected: isChannelDisconnected
                    )
                    self.wsService = nil
                }
            }
        }
        
        func handleWithMessages(
            insert: @escaping (Order.Get) async throws -> Void,
            load: @escaping ([Order.Get]) async throws -> Void,
            update: @escaping (Order.Get) async throws -> Void
        ) {
            Task {
                guard let wsService else {
                    return showError(
                        title: "Failed to connect in the Channel.",
                        description: ""
                    )
                }
                
                do {
                    for try await message in wsService.orderReceivedSubject.values {
                        switch message {
                        case .allOrders(let orders):
                            Task {
                                try await load(orders)
                                
                                await MainActor.run {
                                    viewState = .load
                                }
                            }
                        case .newOrder(let newOrder):
                            Task {
                                try await insert(newOrder)
                            }
                        case .update(let order):
                            Task {
                                try await update(order)
                            }
                        }
                    }
                } catch {
                    showError(
                        title: "Failed to receive orders",
                        description: error.localizedDescription,
                        isChangingViewState: false /* Is set to false, because when some error occur after than the stream starts, will be only display the alert.*/
                    )
                }
            }
        }
        
        #if ADMIN
        func sendUpdatedOrder(with orderID: UUID?, and currentStatus: Status) {
            Task {
                do {
                    guard let orderID else { throw WebSocketConnectionError.receiveDataFailed }
                    
                    guard let wsService else { throw WebSocketConnectionError.noConnection }
                    
                    var newStatus = currentStatus
                    
                    if currentStatus == .ordered {
                        newStatus = .readyForDelivery
                    } else if currentStatus == .readyForDelivery {
                        newStatus = .delivered
                    }
                    
                    let updatedOrder = Order.Update(id: orderID, status: newStatus)
                    let sendMessage: Send = .update(updatedOrder)
                    let message = WebSocketMessage<Send>(data: sendMessage)
                    
                    try await wsService.send(message)
                } catch let error {
                    await MainActor.run {
                        showError(
                            title: "Failed to send update",
                            description: error.localizedDescription,
                            isChangingViewState: false
                        )
                    }
                }
            }
        }
        #endif
        
        private func showError(
            title: String,
            description: String,
            isChangingViewState: Bool = true
        ) {
            alert.setAlert(with: title, and: description)
            wsService = nil
            showingAlert = true
            
            if (isChangingViewState) || (viewState == .loading) {
                viewState = .faliedToLoad
            }
        }
        
        deinit {
            wsService = nil
            print("BagView+ViewModel was deinitialized.")
        }
    }
}
