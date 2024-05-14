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
        @Published var showingError = false
        @Published var error: AppAlert?
        @Published var viewState: ViewState = .load
        
        let cupcake: Cupcake
        
        var extraFrostingPrice: Double {
            Double(order.quantity)
        }
        
        var addSprinklesPrice: Double {
            Double(order.quantity) / 2.0
        }
        
        func makeOrder(_ completationHandler: @escaping () -> Void) {
            Task {
                do {
                    await MainActor.run {
                        viewState = .load
                    }
                    
                    let encoder = JSONEncoder()
                    
                    let encodedOrder = try encoder.encode(order)
                    
                    let tokenValue = try KeychainService.retrive()
                    
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/order/create",
                        values: [
                            .init(value: "application/json", httpHeaderField: .contentType),
                            .init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization)
                        ],
                        httpMethod: .post,
                        type: .uploadData(encodedOrder)
                    )
                    
                    let (_, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    await MainActor.run {
                        viewState = .load
                        completationHandler()
                    }
                } catch let error {
                    await MainActor.run {
                        self.error = AppAlert(title: "Falied To make order", description: error.localizedDescription)
                        viewState = .load
                        showingError = true
                    }
                }
            }
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
