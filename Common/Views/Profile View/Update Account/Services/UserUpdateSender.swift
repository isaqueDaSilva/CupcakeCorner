//
//  UserUpdateSender.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 16/06/24.
//

import Foundation

extension UpdateAccountView {
    enum UserUpdateSender {
        static func update(_ userUpdated: User.Update) async throws -> User.Get {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(userUpdated)
            
            let authenticationValue = try Authentication.value()
            
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/api/user/update",
                values: [
                    .init(value: authenticationValue, httpHeaderField: .authorization),
                    .init(value: "application/json", httpHeaderField: .contentType)
                ],
                httpMethod: .patch,
                type: .uploadData(userData)
            )
            
            let (data, response) = try await request.run()
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw APIError.badResponse
            }
            
            let user = try data.decode(User.Get.self)
            
            return user
        }
    }
}
