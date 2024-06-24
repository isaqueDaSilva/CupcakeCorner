//
//  URLSessionType.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 24/04/24.
//

import Foundation

extension NetworkService {
    /// Stores the all use cases what do you expect receive when some request finish.
    enum URLSessionType {
        /// Use this case when do you wants get only data for the request.
        case getData
        
        /// Use this case when do you want send data for the request.
        case uploadData(Data)
        
        /// A method that get a URLRequest and return a Data and URLResponse tuple value base on the case selected.
        /// - Returns: Returns a Data and URLResponse tuple value base on the case selected.
        func urlSession(for request: URLRequest) async throws -> (Data, URLResponse) {
            switch self {
            case .getData:
                return try await URLSession.shared.data(for: request)
            case .uploadData(let data):
                return try await URLSession.shared.upload(for: request, from: data)
            }
        }
    }
}
