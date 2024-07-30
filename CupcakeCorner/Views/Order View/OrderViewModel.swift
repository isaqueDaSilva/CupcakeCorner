//
//  OrderViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 26/04/24.
//

import Foundation
import NetworkHandler
import SwiftUI

extension OrderView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var order: Order.Create
        @Published var showingAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        @Published var viewState: ViewState = .load
        
        private var task: Task<Void, Never>? = nil
        
        var isSuccessed = false
        
        let cupcake: Cupcake
        
        var extraFrostingPrice: Double {
            Double(order.quantity)
        }
        
        var addSprinklesPrice: Double {
            Double(order.quantity) / 2.0
        }
        
        var subtotal: Double {
            var cupcakeCost: Double {
                cupcake.price * Double(order.quantity)
            }
            
            var extraFrostingTax: Double {
                order.extraFrosting ? extraFrostingPrice : 0
            }
            
            var addSprinklesTax: Double {
                order.addSprinkles ? addSprinklesPrice : 0
            }
            
            let finalPrice = cupcakeCost + extraFrostingTax + addSprinklesTax
            
            return finalPrice
        }
        
        func showingAlert(
            title: String,
            description: String
        ) {
            self.alertTitle = title
            self.alertMessage = description
            self.viewState = .load
            self.showingAlert = true
        }
        
        func makeOrder() {
            task = Task(priority: .background) {
                do {
                    await MainActor.run {
                        viewState = .loading
                        order.finalPrice = subtotal
                    }
                    
                    guard order.cupcake != nil else {
                        throw NetworkService.APIError.fieldsEmpty
                    }
                    
                    let encoder = JSONEncoder()
                    
                    let orderData = try encoder.encode(order)
                    
                    let authenticationValue = try Authentication.value()
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/order/create",
                        values: [
                            .init(value: authenticationValue, httpHeaderField: .authorization),
                            .init(value: "application/json", httpHeaderField: .contentType)
                        ],
                        httpMethod: .post,
                        type: .uploadData(orderData)
                    )
                    
                    let (_, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw NetworkService.APIError.badResponse
                    }
                    
                    await MainActor.run {
                        isSuccessed = true
                        showingAlert(
                            title: "Order Send with Success",
                            description: "Go to the bag and track the progress of your order in real time."
                        )
                    }
                } catch let error {
                    await MainActor.run {
                        showingAlert(
                            title: "Falied to send Order",
                            description: error.localizedDescription
                        )
                    }
                }
            }
        }
        
        func disconnect() {
            task?.cancel()
            task = nil
        }
        
        init(cupcake: Cupcake) {
            _order = Published(
                initialValue: .init(
                    cupcake: cupcake.id,
                    quantity: 1,
                    extraFrosting: false,
                    addSprinkles: false,
                    finalPrice: cupcake.price
                )
            )
            
            self.cupcake = cupcake
        }
    }
}
