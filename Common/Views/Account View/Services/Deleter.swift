//
//  Deleter.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//


import Foundation
import NetworkHandler

extension AccountView {
    enum Deleter {
        static func makeDelete(
            with authenticationValue: String,
            _ session: URLSession = .shared,
            for type: DeleteType
        ) async throws {
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/user/\(type.rawValue)",
                values: [.init(value: authenticationValue, httpHeaderField: .authorization)],
                httpMethod: .delete,
                type: .getData
            )
            
            let (_, response) = try await request.run(with: session)
            
            guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
            else {
                throw NetworkService.APIError.badResponse
            }
        }
    }
}