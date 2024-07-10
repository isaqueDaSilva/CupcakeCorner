//
//  CreateAnAccountViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

extension CreateAnAccountView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var newUser: User.Create
        
        @Published var showingAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        @Published var viewState: ViewState = .load
        @Published var isSuccessed = false
        
        private func showingConfirmationAlert() {
            alertTitle = "Account Created"
            alertMessage = "Your account was created with success, click in OK and log in the system for gets the full access in the App."
            viewState = .load
            showingAlert = true
        }
        
        func createUser() {
            Task(priority: .background) {
                await MainActor.run {
                    self.viewState = .loading
                }
                
                do {
                    let encoder = JSONEncoder()
                    
                    let data = try encoder.encode(newUser)
                    
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
                    
                    await MainActor.run {
                        viewState = .load
                        isSuccessed = true
                        showingConfirmationAlert()
                    }
                } catch let error {
                    await MainActor.run {
                        alertTitle = "Falied to Create User"
                        alertMessage = error.localizedDescription
                        viewState = .load
                        isSuccessed = false
                        showingAlert = true
                    }
                }
            }
        }
        
        init() {
            var role: Role {
                #if CLIENT
                return .client
                #elseif ADMIN
                return .admin
                #endif
            }
            
            var paymentMethod: PaymentMethod {
                #if CLIENT
                return .cash
                #elseif ADMIN
                return .isAdmin
                #endif
            }
            
            _newUser = Published(
                initialValue: .init(
                    name: "",
                    email: "",
                    password: "",
                    confirmPassword: "",
                    role: role,
                    paymentMethod: paymentMethod
                )
            )
        }
    }
}
