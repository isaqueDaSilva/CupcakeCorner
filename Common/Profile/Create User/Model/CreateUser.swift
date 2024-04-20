//
//  CreateUser.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

struct CreateUser: Encodable {
    let name: String
    let email: String
    let password: String
    let confirmPassword: String
    let role: Role
    let paymentMethod: PaymentMethod
    let street: String?
    let city: String?
    let zip: String?
}
