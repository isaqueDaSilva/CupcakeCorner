//
//  ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//


import Foundation
import NetworkHandler

extension UpdateAccountView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var name: String
        @Published var paymentMethod: PaymentMethod
        
        @Published var viewState: ViewState = .load
       
        @Published var showingAlert = false
        @Published var alert = AlertHandler()
        @Published var isSuccessed = false
        
        private let currentUserName: String
        private let currentUserPayment: PaymentMethod
        
        private func showingConfirmationAlert() {
            alert.setAlert(
                with: "Account Updated",
                and: "Your account was updated with success, click in OK and continue navigating on App."
            )
            viewState = .load
            showingAlert = true
        }
        
        func sendUpdate(
            with completation: @escaping (User.Get) async throws-> Void
        ) {
            Task {
                do {
                    await MainActor.run {
                        viewState = .loading
                    }
                    
                    guard currentUserName != name || currentUserPayment != paymentMethod else {
                        throw NetworkService.APIError.noChanges
                    }
                    
                    let updatedUser = User.Update(name: name, paymentMethod: paymentMethod)
                    
                    let updatedUserData = try JSONEncoder().encode(updatedUser)
                    
                    let authenticationValue = try TokenGetter.getValue()
                    
                    let userUpdated = try await UserUpdateSender.update(
                        with: updatedUserData,
                        authenticationValue
                    )
                    
                    try await completation(userUpdated)
                    
                    await MainActor.run {
                        viewState = .load
                        isSuccessed = true
                        showingConfirmationAlert()
                    }
                } catch let error {
                    await MainActor.run {
                        alert.setAlert(
                            with: "Falied to Update User",
                            and: error.localizedDescription
                        )
                        viewState = .load
                        showingAlert = true
                    }
                }
            }
        }
        
        init(
            with name: String,
            and paymentMethod: PaymentMethod
        ) {
            _name = Published(initialValue: name)
            _paymentMethod = Published(initialValue: paymentMethod)
            
            self.currentUserName = name
            self.currentUserPayment = paymentMethod
        }
    }
}
