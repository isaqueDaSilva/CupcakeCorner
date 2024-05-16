//
//  OrderViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 26/04/24.
//

import Foundation
import SwiftUI

extension OrderView {
    final class ViewModel: ObservableObject {
        @Published var order: Order.Create
        @Published var showingAlert = false
        @Published var alert: AppAlert?
        @Published var viewState: ViewState = .load
        @Published var task: Task<Void, Never>? = nil
        
        var isSuccessed = false
        
        let cupcake: Cupcake.Get
        
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
            self.alert = AppAlert(title: title, description: description)
            self.viewState = .load
            self.showingAlert = true
        }
        
        func makeOrder() {
            task = Task {
                do {
                    await MainActor.run {
                        viewState = .loading
                        order.finalPrice = subtotal
                    }
                    
                    let encoder = JSONEncoder()
                    
                    let orderData = try encoder.encode(order)
                    
                    let tokenValue = try KeychainService.retrive()
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/order/create",
                        values: [
                            .init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization),
                            .init(value: "application/json", httpHeaderField: .contentType)
                        ],
                        httpMethod: .post,
                        type: .uploadData(orderData)
                    )
                    
                    let (_, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    await MainActor.run {
                        isSuccessed = true
                        showingAlert(title: "Order Send with Success", description: "")
                    }
                } catch let error {
                    await MainActor.run {
                        showingAlert(title: "Falied to send Order", description: error.localizedDescription)
                    }
                }
            }
        }
        
        init(cupcake: Cupcake.Get) {
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
