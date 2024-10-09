//
//  AuthorizationHeader.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/28/24.
//

import Foundation

enum AuthorizationHeader: String {
    /// Indicates that we send an authorization request.
    case bearer = "Bearer"
    
    /// Indicates that we send an authentication request.
    case basic = "Basic"
}
