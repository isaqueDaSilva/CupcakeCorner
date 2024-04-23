//
//  Login.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

struct Login {
    private let email: String
    private let password: String
    
    private func value() throws -> String {
        let loginData = ("\(email):\(password)".data(using: .utf8)?.base64EncodedString())
        let basicValue = AuthorizationHeader.basic.rawValue
        
        guard let loginData else {
            throw APIError.fieldsEmpty
        }
        
        return "\(basicValue) \(loginData)"
    }
    
    func login() async throws {
        let endpoint = "http://127.0.0.1:8080/api/login"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.badURL
        }
        
        guard !email.isEmpty && !password.isEmpty else {
            throw APIError.fieldsEmpty
        }
        
        let value = try self.value()
        
        var request = URLRequest(url: url)
        request.setValue(value, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.post.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let token = try decoder.decode(Token.self, from: data)
        
        _ = try KeychainService.store(for: token)
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
