//
//  Errors.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

struct AppError {
    let title: String
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

enum APIError: Error {
    case badURL
    case badEncoding
    case badResponse
    case unknown(Error)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badURL:
            NSLocalizedString("We are having a problem with this URL, please try again later or contact us.", comment: "")
        case .badEncoding:
            NSLocalizedString("Unable to encode data, please try again or contact us.", comment: "")
        case .badResponse:
            NSLocalizedString("There was a problem getting a response, please check your connection and try again or contact us.", comment: "")
        case .unknown(let error):
            NSLocalizedString("An unknown error \(error) was generated.", comment: "")
        }
    }
}
