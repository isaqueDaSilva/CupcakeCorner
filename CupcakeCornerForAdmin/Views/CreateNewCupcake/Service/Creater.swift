//
//  Creater.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//


import Foundation
import NetworkHandler

extension CreateCupcakeView {
    enum Creater {
        static func create(with cupcake: Cupcake.Create) async throws -> Cupcake.Get {
            let encoder = JSONEncoder()
            let cupcakeData = try encoder.encode(cupcake)
            
            let authenticationValue = try TokenGetter.getValue()
            
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/cupcake/create",
                values: [
                    .init(value: authenticationValue, httpHeaderField: .authorization),
                    .init(value: "application/json", httpHeaderField: .contentType)
                ],
                httpMethod: .post,
                type: .uploadData(cupcakeData)
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