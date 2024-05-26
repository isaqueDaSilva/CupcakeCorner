//
//  AuthorizationHeader.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

/// A representation Model for the authorization header
/// used in the App for makes an authorization request.
enum AuthorizationHeader: String {
    case bearer = "Bearer"
    case basic = "Basic"
}
