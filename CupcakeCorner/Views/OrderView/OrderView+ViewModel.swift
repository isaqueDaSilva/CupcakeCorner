//
//  OrderView+ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/28/24.
//

import Foundation
import NetworkHandler

extension OrderView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var orderRequest: Order.Create
        @Published var viewState: ViewState = .load
        @Published var alert = AlertHandler()
        @Published var isAlertDisplaying = false
        
        var isSuccessed = false
        
        var isDisable: Bool {
            viewState == .loading
        }
        
        func makeOrder() {
            Task {
                await MainActor.run {
                    viewState = .loading
                }
                
                do {
                    guard let orderData = try? JSONEncoder().encode(orderRequest) else {
                        throw NetworkService.APIError.badEncoding
                    }
                    
                    let authenticationValue = try TokenGetter.getValue()
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/order/create",
                        values: [
                            .init(value: authenticationValue, httpHeaderField: .authorization),
                            .init(value: "application/json", httpHeaderField: .contentType)
                        ],
                        httpMethod: .post,
                        type: .uploadData(orderData)
                    )
                    
                    guard let (_, response) = try? await request.run() else {
                        throw NetworkService.APIError.runFailed
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw NetworkService.APIError.badResponse
                    }
                    
                    isSuccessed = true
                    
                    await MainActor.run {
                        alert.setAlert(
                            with: "Order Send with Success",
                            and: "Go to the bag and track the progress of your order in real time."
                        )
                        
                        viewState = .load
                        
                        isAlertDisplaying = true
                    }
                } catch {
                    alert.setAlert(
                        with: "Failed to send order",
                        and: error.localizedDescription
                    )
                    
                    viewState = .faliedToLoad
                    
                    isAlertDisplaying = true
                }
            }
        }
        
        init(with cupcakeID: UUID, and cupcakePrice: Double) {
            _orderRequest = .init(
                wrappedValue: .init(
                    cupcake: cupcakeID,
                    quantity: 1,
                    extraFrosting: false,
                    addSprinkles: false,
                    basePrice: cupcakePrice
                )
            )
        }
    }
}
