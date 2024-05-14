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
        
        #if CLIENT
        @Published var fullAdress: String = ""
        @Published var city: String = ""
        @Published var zip: String = ""
        #endif
        
        @Published var showingError = false
        @Published var error: AppAlert?
        
        @Published var viewState: ViewState = .load
        
        func createUser(_ completationHandler: @escaping () -> Void) {
            Task {
                await MainActor.run {
                    viewState = .loading
                }
                
                do {
                    #if CLIENT
                    newUser.fullAdress = self.fullAdress
                    newUser.city = self.city
                    newUser.zip = self.zip
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
                    
                    completationHandler()
                } catch let error {
                    await MainActor.run {
                        self.error = AppAlert(title: "Falied to Create User", description: error.localizedDescription)
                        viewState = .load
                        showingError = true
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
