//
//  CreateAnAccountViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

extension CreateAnAccount {
    @Observable
    final class ViewModel {
        var name: String = ""
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        
        var role: Role {
            #if CLIENT
            return .client
            #elseif ADMIN
            return .admin
            #endif
        }
        
        var paymentMethod: PaymentMethod = .cash
        var street: String = ""
        var city: String = ""
        var zip: String = ""
        
        var showingError = false
        var error: AppError?
        
        var viewState: ViewState = .load
        
        func createUser(_ completationHandler: @escaping () -> Void) {
            Task {
                await MainActor.run {
                    viewState = .loading
                }
                
                do {
                    let newUser = CreateUser(
                        name: self.name,
                        email: self.email,
                        password: self.password,
                        confirmPassword: self.confirmPassword,
                        role: self.role,
                        paymentMethod: self.role == .admin ? .isAdmin : self.paymentMethod,
                        street: self.role == .admin ? nil : self.street,
                        city: self.role == .admin ? nil : self.city,
                        zip: self.role == .admin ? nil : self.zip
                    )
                    
                    let encoder = JSONEncoder()
                    
                    guard let data = try? encoder.encode(newUser) else {
                        throw APIError.badEncoding
                    }
                    
                    let request = NetworkService.init(
                        endpoint: "http://127.0.0.1:8080/api/user/create",
                        values: [.init(value: "application/json", httpHeaderField: .contentType)],
                        httpMethod: .post,
                        type: .uploadData(data)
                    )
                    
                    let (_, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    completationHandler()
                } catch let error {
                    await MainActor.run {
                        self.error = AppError(title: "Falied to Create User", description: error.localizedDescription)
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
    }
}
