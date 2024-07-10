//
//  UpdateAccountViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/06/24.
//

import Foundation
import SwiftData

extension UpdateAccountView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var name: String
        @Published var paymentMethod: PaymentMethod
        
        @Published var viewState: ViewState = .load
        
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        @Published var showingAlert = false
        @Published var isSuccessed = false
        
        private func showingConfirmationAlert() {
            alertTitle = "Account Updated"
            alertMessage = "Your account was updated with success, click in OK and continue navigating on App."
            viewState = .load
            showingAlert = true
        }
        
        func sendUpdate(
            with user: User,
            and context: ModelContext,
            _ completation: @escaping () -> Void
        ) {
            Task {
                do {
                    await MainActor.run {
                        viewState = .loading
                    }
                    
                    guard user.name != name || user.paymentMethod != paymentMethod else {
                        throw APIError.noChanges
                    }
                    
                    let updatedUser = User.Update(name: name, paymentMethod: paymentMethod)
                    let userUpdated = try await UserUpdateSender.update(updatedUser)
                    
                    if user.name != userUpdated.name {
                        user.name = userUpdated.name
                    }
                    
                    if user.paymentMethod != userUpdated.paymentMethod {
                        user.paymentMethod = userUpdated.paymentMethod
                    }
                    
                    try context.save()
                    
                    await MainActor.run {
                        completation()
                        viewState = .load
                        isSuccessed = true
                        showingConfirmationAlert()
                    }
                } catch let error {
                    await MainActor.run {
                        self.alertTitle = "Falied to Update User"
                        alertMessage = error.localizedDescription
                        viewState = .load
                        showingAlert = true
                    }
                }
            }
        }
        
        init(user: User) {
            _name = Published(initialValue: user.name)
            _paymentMethod = Published(initialValue: user.paymentMethod)
        }
    }
}
