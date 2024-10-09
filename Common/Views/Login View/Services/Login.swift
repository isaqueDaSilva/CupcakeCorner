//
//  Login.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/6/24.
//

import Foundation
import NetworkHandler

extension LoginView {
    struct Login {
        var email: String
        var password: String
        
        private func value() throws -> String {
            guard !email.isEmpty && !password.isEmpty else {
                throw NetworkService.APIError.fieldsEmpty
            }
            
            let loginData = ("\(email):\(password)".data(using: .utf8)?.base64EncodedString())
            let basicValue = AuthorizationHeader.basic.rawValue
            
            guard let loginData else {
                throw NetworkService.APIError.badEncoding
            }
            
            return "\(basicValue) \(loginData)"
        }
        
        private var appType: String {
            #if CLIENT
            return LoginType.forClient.rawValue
            #elseif ADMIN
            return LoginType.forAdmin.rawValue
            #endif
        }
        
        func makeLogin(with session: URLSession = .shared) async throws -> LoginResponse {
            let value = try self.value()
            
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/login/\(appType)",
                values: [.init(value: value, httpHeaderField: .authorization)],
                httpMethod: .post,
                type: .getData
            )
            
            let (data, response) = try await request.run(with: session)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let response = response as? HTTPURLResponse
                
                if response?.statusCode == 401 {
                    throw NetworkService.APIError.accessDenied
                } else {
                    throw NetworkService.APIError.badResponse
                }
            }
            
            let decoder = JSONDecoder()
            
            let loginResponse = try decoder.decode(LoginResponse.self, from: data)
            
            return loginResponse
        }
        
        init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
}

extension LoginView.Login {
    enum LoginType: String {
        case forAdmin
        case forClient
    }
}
