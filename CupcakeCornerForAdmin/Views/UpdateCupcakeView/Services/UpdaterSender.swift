//
//  UpdaterSender.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/3/24.
//

import Foundation
import NetworkHandler

extension UpdateCupcakeView {
    enum UpdaterSender {
        static func send(_ updatedCupcake: Cupcake.Update, for cupcakeID: UUID) async throws -> Cupcake.Get {
            let encoder = JSONEncoder()
            let updatedCupcakeData = try encoder.encode(updatedCupcake)
            
            let authenticationValue = try TokenGetter.getValue()
            
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/cupcake/update/\(cupcakeID)",
                values: [
                    .init(value: authenticationValue, httpHeaderField: .authorization),
                    .init(value: "application/json", httpHeaderField: .contentType)
                ],
                httpMethod: .patch,
                type: .uploadData(updatedCupcakeData)
            )
            
            let (data, response) = try await request.run()
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw NetworkService.APIError.badResponse
            }
            
            let cupcakeResult = try data.decode(Cupcake.Get.self)
            
            return cupcakeResult
        }
    }
}
