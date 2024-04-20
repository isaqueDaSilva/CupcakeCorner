//
//  KeychainError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

extension KeychainService {
    enum KeychainError: Error, LocalizedError {
        case saveError
        case noToken
        case unexpectedTokenData
        case unhandledError(status: OSStatus)
        
        var errorDescription: String? {
            switch self {
            case .saveError, .unexpectedTokenData:
                NSLocalizedString("An internal error has occurred, please try again or contact us.", comment: "")
            case .noToken:
                NSLocalizedString("No item saved, you need to make login before to continue.", comment: "")
            case .unhandledError(let status):
                NSLocalizedString("An unexpected error occurred: \(status)", comment: "")
            }
        }
    }
}
