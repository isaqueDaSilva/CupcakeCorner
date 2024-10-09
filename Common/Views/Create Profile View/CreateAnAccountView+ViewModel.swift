//
//  ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//


import Foundation
import NetworkHandler

extension CreateAnAccountView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var newUser: User.Create
        
        @Published var showingAlert = false
        @Published var alert = AlertHandler()
        
        @Published var viewState: ViewState = .load
        @Published var isSuccessed = false
        
        private func showingConfirmationAlert() {
            alert.setAlert(
                with: "Account Created",
                and: "Your account was created with success, click in OK and log in the system for gets the full access in the App."
            )
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
                    
                    var values: [NetworkService.Values] = [
                        .init(value: "application/json", httpHeaderField: .contentType)
                    ]
                    
                    #if ADMIN
                    let token = try TokenGetter.getValue()
                    values.append(.init(value: token, httpHeaderField: .authorization))
                    #endif
                    
                    var endpoint: String {
                        #if ADMIN
                        return "http://127.0.0.1:8080/user/create-admin"
                        #elseif CLIENT
                        return "http://127.0.0.1:8080/user/create"
                        #endif
                    }
                    
                    let request = NetworkService(
                        endpoint: endpoint,
                        values: values,
                        httpMethod: .post,
                        type: .uploadData(data)
                    )
                    
                    guard let (_, response) = try? await request.run() else {
                        throw NetworkService.APIError.runFailed
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw NetworkService.APIError.badResponse
                    }
                    
                    await MainActor.run {
                        viewState = .load
                        isSuccessed = true
                        showingConfirmationAlert()
                    }
                } catch let error {
                    await MainActor.run {
                        alert.setAlert(
                            with: "Falied to Create User",
                            and: error.localizedDescription
                        )
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