//
//  Authentication.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 07/06/24.
//

import Foundation
import KeychainService

/// Stores a method that gets a Token value stored in Keychain.
enum TokenGetter {
    static func getValue() throws -> String {
        let tokenValue = try KeychainService.retrive(Token.self)
        let bearerValue = AuthorizationHeader.bearer.rawValue
        
        return "\(bearerValue) \(tokenValue)"
    }
}
