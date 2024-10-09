//
//  LoginResponse.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

struct LoginResponse: Codable, Equatable {
    let jwtToken: Token
    let userProfile: User.Get
}
