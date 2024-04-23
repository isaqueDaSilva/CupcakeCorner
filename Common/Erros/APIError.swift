//
//  APIError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

enum APIError: Error {
    case badURL
    case badEncoding
    case badResponse
    case incorrectAuthenticationMethod
    case fieldsEmpty
    case accessDenied
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
        case .accessDenied:
            NSLocalizedString("You do not have permission to access this route.", comment: "")
        case .incorrectAuthenticationMethod:
            NSLocalizedString("Unable to login, please try again.", comment: "")
        case .fieldsEmpty:
            NSLocalizedString("There are empty fields in the form, please fill them in before proceeding.", comment: "")
        }
    }
}
