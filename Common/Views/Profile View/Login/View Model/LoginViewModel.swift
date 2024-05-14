//
//  LoginViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

extension LoginView {
    final class ViewModel: ObservableObject {
        @Published var login: Login
        
        var viewState: ViewState = .load
        
        var showingError = false
        var error: AppAlert?
        
        let persistenceStore = SwiftDataService<User>()
        
        func login(_ completation: @escaping () -> Void) {
            Task {
                await MainActor.run {
                    viewState = .loading
                }
                
                do {
                    guard !login.email.isEmpty && !login.password.isEmpty else {
                        throw APIError.fieldsEmpty
                    }
                    
                    try await login.makeLogin()
                    
                    let tokenValue = try KeychainService.retrive()
                    
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/user/get",
                        values: [.init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization)],
                        httpMethod: .get,
                        type: .getData
                    )
                    
                    let (data, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.accessDenied
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let userGetted = try decoder.decode(User.Get.self, from: data)
                    
                    let user = User(from: userGetted)
                    try persistenceStore.create(new: user)
                    
                    await MainActor.run {
                        viewState = .load
                        completation()
                    }
                } catch let error {
                    await MainActor.run {
                        self.error = AppAlert(title: "Login Falied", description: error.localizedDescription)
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init() {
            _login = Published(initialValue: .init(email: "", password: ""))
        }
    }
}
