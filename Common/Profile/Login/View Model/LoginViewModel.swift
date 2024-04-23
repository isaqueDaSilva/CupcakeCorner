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
        
        var showingError = false
        var error: AppError?
        
        let persistenceStore = SwiftDataService<User>()
        
        func login(_ completation: @escaping () -> Void) {
            Task {
                await MainActor.run {
                    viewState = .loading
                }
                
                do {
                    let userCredentials = Login(email: self.email, password: self.password)
                    try await userCredentials.login()
                    
                    let endpoint = "http://127.0.0.1:8080/api/user/get"
                    
                    guard let url = URL(string: endpoint) else {
                        throw APIError.badURL
                    }
                    
                    let tokenValue = try KeychainService.retrive()
                    
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    var request = URLRequest(url: url)
                    request.setValue("\(bearerValue) \(tokenValue)", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
                    request.httpMethod = HTTPMethod.get.rawValue
                    
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let userData = try decoder.decode(UserPublic.self, from: data)
                    
                    let user = User(from: userData)
                    
                    try persistenceStore.create(new: user)
                    
                    await MainActor.run {
                        viewState = .load
                        completation()
                    }
                } catch let error {
                    self.error = AppError(title: "Login Falied", description: error.localizedDescription)
                    viewState = .load
                    showingError = true
                }
            }
        }
    }
}
