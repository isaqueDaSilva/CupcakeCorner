//
//  LoginHandler.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 16/06/24.
//

import Foundation
import NetworkHandler

extension LoginView {
    enum LoginHandler {
        static func makeLogin(with credentials: Login) async throws -> User.Get {
            try await credentials.getTokenValue()
            let authenticationValue = try Authentication.value()
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/api/user/get",
                values: [.init(value: authenticationValue, httpHeaderField: .authorization)],
                httpMethod: .get,
                type: .getData
            )
            
            let (data, response) = try await request.run()
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                    throw NetworkService.APIError.accessDenied
                } else {
                    throw NetworkService.APIError.badResponse
                }
            }
            
            let userGetted = try data.decode(User.Get.self)
            
            return userGetted
        }
    }
}
