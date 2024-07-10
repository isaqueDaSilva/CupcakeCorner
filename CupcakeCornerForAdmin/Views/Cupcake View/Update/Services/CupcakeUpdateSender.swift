//
//  CupcakeUpdateSender.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 16/06/24.
//

import Foundation

extension UpdateCupcakeView {
    enum CupcakeUpdateSender {
        static func send(_ updatedCupcake: Cupcake.Update, for cupcakeID: UUID) async throws -> Cupcake.Get {
            let encoder = JSONEncoder()
            let updatedCupcakeData = try encoder.encode(updatedCupcake)
            
            let authenticationValue = try Authentication.value()
            
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/api/cupcake/update/\(cupcakeID)",
                values: [
                    .init(value: authenticationValue, httpHeaderField: .authorization),
                    .init(value: "application/json", httpHeaderField: .contentType)
                ],
                httpMethod: .patch,
                type: .uploadData(updatedCupcakeData)
            )
            
            let (data, response) = try await request.run()
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw APIError.badResponse
            }
            
            let cupcakeResult = try data.decode(Cupcake.Get.self)
            
            return cupcakeResult
        }
    }
}
