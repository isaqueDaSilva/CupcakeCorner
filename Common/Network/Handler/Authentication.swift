//
//  Authentication.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 07/06/24.
//

import Foundation

/// Stores a method that gets a Token value stored in Keychain.
enum Authentication {
    static func value() throws -> String {
        let tokenValue = try KeychainService.retrive()
        let bearerValue = AuthorizationHeader.bearer.rawValue
        
        return "\(bearerValue) \(tokenValue)"
    }
}
