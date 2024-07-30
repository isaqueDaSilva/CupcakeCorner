//
//  User.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import CoreData
import Foundation

extension User {
    /// An user's data representation for decoding data that coming from the API request when is finished.
    struct Get: Codable, Sendable {
        let id: UUID
        let name: String
        let email: String
        let role: Role
        let paymentMethod: PaymentMethod
    }
}

extension User {
    /// A representation of the data that used for create an user.
    struct Create: Encodable, Sendable {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
        let role: Role
        var paymentMethod: PaymentMethod
        
        init(
            name: String,
            email: String,
            password: String,
            confirmPassword: String,
            role: Role,
            paymentMethod: PaymentMethod
        ) {
            self.name = name
            self.email = email
            self.password = password
            self.confirmPassword = confirmPassword
            self.role = role
            self.paymentMethod = paymentMethod
        }
    }
}

extension User {
    /// A representation of the data that used for update an user..
    struct Update: Encodable, Sendable {
        let name: String?
        let paymentMethod: PaymentMethod?
    }
}
