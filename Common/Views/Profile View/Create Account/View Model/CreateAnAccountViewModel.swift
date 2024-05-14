//
//  CreateAnAccountViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

extension CreateAnAccount {
    final class ViewModel: ObservableObject {
        @Published var newUser: User.Create
        @Published var task: Task<Void, Never>? = nil
        
        #if CLIENT
        @Published var fullAdress: String = ""
        @Published var city: String = ""
        @Published var zip: String = ""
        #endif
        
        @Published var showingAlert = false
        @Published var alert: AppAlert?
        
        @Published var viewState: ViewState = .load
        @Published var isSuccessed = false
        
        private func showingConfirmationAlert() {
            alert = AppAlert(
                title: "Account Created",
                description: "Your account was created with success, click in OK and log in the system for gets the full access in the App."
            )
            viewState = .load
            showingAlert = true
        }
        
        func createUser() {
            task = Task {
                await MainActor.run {
                    viewState = .loading
                }
                
                do {
                    #if CLIENT
                    await MainActor.run {
                        newUser.fullAdress = self.fullAdress
                        newUser.city = self.city
                        newUser.zip = self.zip
                    }
                    #endif
                    
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
                    
                    await MainActor.run {
                        viewState = .load
                        isSuccessed = true
                        showingConfirmationAlert()
                    }
                } catch let error {
                    await MainActor.run {
                        self.alert = AppAlert(title: "Falied to Create User", description: error.localizedDescription)
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
