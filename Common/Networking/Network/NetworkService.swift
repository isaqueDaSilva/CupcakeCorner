//
//  NetworkService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 24/04/24.
//

import Foundation

struct NetworkService {
    private let endpoint: String
    private let values: [Values]
    private let httpMethod: String
    private let type: URLSessionType
    
    private func getURL() throws -> URL {
        guard let url = URL(string: endpoint) else {
            throw APIError.badURL
        }
        
        return url
    }
    
    private func makeRequest() throws -> URLRequest {
        let url = try getURL()
        
        var request = URLRequest(url: url)
        
        for value in values {
            request.setValue(value.value, forHTTPHeaderField: value.httpHeaderField)
        }
        
        request.httpMethod = httpMethod
        
        return request
    }
    
    func run() async throws -> (Data, URLResponse) {
        let request = try makeRequest()
        return try await type.urlSession(for: request)
    }
    
    init(
        endpoint: String,
        values: [Values] = [],
        httpMethod: HTTPMethod,
        type: URLSessionType
    ) {
        self.endpoint = endpoint
        self.values = values
        self.httpMethod = httpMethod.rawValue
        self.type = type
    }
}
