//
//  CupcakeGetter.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 13/06/24.
//

import Foundation

extension CupcakeView {
    enum CupcakeGetter {
        /// Perform a fetch request for gets new cupcakes from the backend service.
        static func get() async throws -> [Cupcake.Get] {
            
            let request = NetworkService(
                endpoint: "http://127.0.0.1:8080/api/cupcake/all",
                httpMethod: .get,
                type: .getData
            )
            
            let (data, response) = try await request.run()
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw APIError.badResponse
            }
            
            guard let newCupcakes = try? data.decode([Cupcake.Get].self) else {
                throw APIError.badDecoding
            }
            
            return newCupcakes
        }
    }
}
