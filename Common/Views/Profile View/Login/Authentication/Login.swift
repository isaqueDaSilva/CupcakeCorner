//
//  Login.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation
import KeychainService
import NetworkHandler

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
    
    func getTokenValue() async throws {
        let value = try self.value()
        
        let request = NetworkService(
            endpoint: "http://127.0.0.1:8080/api/login/\(appType)",
            values: [.init(value: value, httpHeaderField: .authorization)],
            httpMethod: .post,
            type: .getData
        )
        
        let (data, response) = try await request.run()
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            let response = response as? HTTPURLResponse
            
            if response?.statusCode == 401 {
                throw NetworkService.APIError.accessDenied
            } else {
                throw NetworkService.APIError.badResponse
            }
        }
        
        let decoder = JSONDecoder()
        
        let token = try decoder.decode(Token.self, from: data)
        
        _ = try KeychainService.store(for: token)
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
