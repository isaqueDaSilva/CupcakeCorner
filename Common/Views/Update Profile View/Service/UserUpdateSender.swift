//
//  UserUpdateSender.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//


import Foundation
import NetworkHandler

extension UpdateAccountView {
    enum UserUpdateSender {
        static func update(
            with updatedUserData: Data,
            _ authenticationValue: String,
            and session: URLSession = .shared
        ) async throws -> User.Get {
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/user/update",
                values: [
                    .init(
                        value: authenticationValue,
                        httpHeaderField: .authorization
                    ),
                    .init(
                        value: "application/json",
                        httpHeaderField: .contentType
                    )
                ],
                httpMethod: .patch,
                type: .uploadData(updatedUserData)
            )
            
            let (data, response) = try await request.run(with: session)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw NetworkService.APIError.badResponse
            }
            
            let user = try data.decode(User.Get.self)
            
            return user
        }
    }
}