//
//  CupcakeDeleteSender.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 16/06/24.
//

import Foundation
import NetworkHandler

extension CupcakeDetailView {
    enum CupcakeDeleteSender {
        static func deleteCupcakeReq(with cupcakeID: UUID) async throws {
            let authenticationValue = try Authentication.value()
            
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/api/cupcake/delete/\(cupcakeID)",
                values: [.init(value: authenticationValue, httpHeaderField: .authorization)],
                httpMethod: .delete,
                type: .getData
            )
            
            let (_, response) = try await request.run()
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw NetworkService.APIError.badResponse
            }
        }
    }
}
