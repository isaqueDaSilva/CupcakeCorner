//
//  TokenGetter.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/28/24.
//

import Foundation
import KeychainService

enum TokenGetter {
    /// Gets a token value saved in Keychain,
    /// and creates an authorization header for send in HTTP request.
    /// - Returns: Returns a String value with an authorization header.
    static func getValue(with token: Token? = nil) throws -> String {
        let bearerValue = AuthorizationHeader.bearer.rawValue
        
        if let tokenValue = token {
            return "\(bearerValue) \(tokenValue.token)"
        } else {
            let tokenValue = try KeychainService.retrive(Token.self)
            return "\(bearerValue) \(tokenValue.token)"
        }
    }
}
