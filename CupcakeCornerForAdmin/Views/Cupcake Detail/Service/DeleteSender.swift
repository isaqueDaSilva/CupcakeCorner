//
//  DeleteSender.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/3/24.
//

import Foundation
import NetworkHandler

extension CupcakeDetailView {
    enum DeleteSender {
        static func delete(with cupcakeID: UUID) async throws {
            let authenticationValue = try TokenGetter.getValue()
            
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/cupcake/delete/\(cupcakeID)",
                values: [.init(value: authenticationValue, httpHeaderField: .authorization)],
                httpMethod: .delete,
                type: .getData
            )
            
            guard let (_, response) = try? await request.run() else {
                throw NetworkService.APIError.runFailed
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw NetworkService.APIError.badResponse
            }
        }
    }
}
