//
//  LoginViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

extension LoginView {
    @Observable
    final class ViewModel {
        var email = ""
        var password = ""
        
        var viewState: ViewState = .load
        
        private var authorized = false {
            didSet {
                UserDefaults.standard.set(authorized, forKey: Keys.authorized.rawValue)
            }
        }
        
        var showingError = false
        var error: AppError?
        
        func login() {
            Task {
                await MainActor.run {
                    viewState = .loading
                }
                
                do {
                    let userCredentials = Login(email: self.email, password: self.password)
                    let tokenValue = try await userCredentials.login()
                    
                    let endpoint = "http://127.0.0.1:8080/api/login"
                    
                    guard let url = URL(string: endpoint) else {
                        throw APIError.badURL
                    }
                    
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    var request = URLRequest(url: url)
                    request.setValue("\(bearerValue) \(tokenValue.value)", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
                    request.httpMethod = HTTPMethod.get.rawValue
                    
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    let decoder = JSONDecoder()
                    
                    let token = try decoder.decode(Token.self, from: data)
                    
                    _ = try KeychainService.store(for: token)
                    
                    await MainActor.run {
                        viewState = .load
                    }
                    
                    authorized = true
                } catch let error {
                    self.error = AppError(title: "Login Falied", description: error.localizedDescription)
                    viewState = .load
                    showingError = true
                }
            }
        }
    }
}
