//
//  CupcakeGetter.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/30/24.
//


import Foundation
import NetworkHandler

extension CupcakeView {
    enum Getter {
        /// Perform a fetch request for gets new cupcakes from the backend service.
        static func get(with session: URLSession = .shared, authorizationKey: String) async throws -> [Cupcake.Get] {
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/cupcake/all",
                values: [.init(value: authorizationKey, httpHeaderField: .authorization)],
                httpMethod: .get,
                type: .getData
            )
            
            let (data, response) = try await request.run(with: session)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw NetworkService.APIError.badResponse
            }
            
            guard let newCupcakes = try? data.decode([Cupcake.Get].self) else {
                throw NetworkService.APIError.badDecoding
            }
            
            return newCupcakes
        }
    }
}
