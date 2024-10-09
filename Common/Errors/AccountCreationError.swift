//
//  AccountCreationError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

extension User.Create {
    enum AccountCreationError: Error, LocalizedError {
        case fieldsNotMatch
        case encodingFailure
        
        var errorDescription: String? {
            switch self {
            case .fieldsNotMatch:
                "Password and Confirm password field not match.\nPlease fix those before to create your account."
            case .encodingFailure:
                "Something went wrong while processing your request. Please try again or contact us."
            }
        }
    }
}
