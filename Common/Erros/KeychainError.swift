//
//  KeychainError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

extension KeychainService {
    
    /// An representation of the errors that may be occur on a operation of the Keychain .
    enum KeychainError: Error, LocalizedError {
        
        /// This error is for time when saving operation has failed.
        case saveError
        
        /// This error is for time when the searching operation don't find any item.
        case noToken
        
        /// This error is for time when the unexpected token data is find.
        case unexpectedTokenData
        
        /// This error is for time when the unknown error is find
        case unhandledError(status: OSStatus)
        
        var errorDescription: String? {
            switch self {
            case .saveError:
                NSLocalizedString("Failed to save your token in the Keychain. Please try again", comment: "")
            case .unexpectedTokenData:
                NSLocalizedString("A unknown data type was decoded. Please try again", comment: "")
            case .noToken:
                NSLocalizedString("No item saved, you need to make login before to continue.", comment: "")
            case .unhandledError(let status):
                NSLocalizedString("An unexpected error occurred: \(status)", comment: "")
            }
        }
    }
}
