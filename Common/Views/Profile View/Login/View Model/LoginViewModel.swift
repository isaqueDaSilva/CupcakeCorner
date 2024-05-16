//
//  LoginViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

extension LoginView {
    final class ViewModel: ObservableObject {
        @Published var loginCredentials: Login
        @Published var viewState: ViewState = .load
        @Published var showingError = false
        @Published var error: AppAlert?
        
        @Published var task: Task<Void, Never>? = nil
        
        func login(
            _ completation: @escaping () -> Void,
            cacheUser: @escaping (User.Get) throws -> Void
        ) {
            task = Task {
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    let tokenValue = try await loginCredentials.getTokenValue()
                    
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
                    
                    let userGetted = try decoder.decode(User.Get.self, from: data)
                    
                    try await MainActor.run {
                        self.viewState = .load
                        try cacheUser(userGetted)
                        completation()
                    }
                } catch let error {
                    await MainActor.run {
                        self.error = AppAlert(title: "Login Falied", description: error.localizedDescription)
                        self.viewState = .load
                        self.showingError = true
                    }
                }
            }
        }
        
        init() {
            _loginCredentials = Published(initialValue: .init(email: "", password: ""))
        }
    }
}
