//
//  LoginView+LoginError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 8/9/24.
//

import Foundation

extension LoginView {
    enum LoginError: Error, LocalizedError {
        case unauthorized
        
        var errorDescription: String? {
            switch self {
            case .unauthorized:
                "You do not authorized to access this profile.\nChecks if you write all informations correctly or contact us."
            }
        }
    }
}
