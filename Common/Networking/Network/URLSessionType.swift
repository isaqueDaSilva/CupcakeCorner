//
//  URLSessionType.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 24/04/24.
//

import Foundation

extension NetworkService {
    enum URLSessionType {
        case getData
        case uploadData(Data)
        
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
