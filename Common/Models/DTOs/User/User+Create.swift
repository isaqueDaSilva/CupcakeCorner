//
//  User+Create.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

extension User {
    /// A representation of the data that used for create an user.
    struct Create: Encodable, Sendable {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
        var role: Role
        var paymentMethod: PaymentMethod
        
        enum CodingKeys: CodingKey {
            case name
            case email
            case password
            case role
            case paymentMethod
        }
        
        func encode(to encoder: any Encoder) throws(AccountCreationError) {
            guard password == confirmPassword else {
                throw .fieldsNotMatch
            }
            
            do {
                var container: KeyedEncodingContainer<User.Create.CodingKeys> = encoder.container(keyedBy: User.Create.CodingKeys.self)
                try container.encode(self.name, forKey: User.Create.CodingKeys.name)
                try container.encode(self.email, forKey: User.Create.CodingKeys.email)
                try container.encode(self.password, forKey: User.Create.CodingKeys.password)
                try container.encode(self.role, forKey: User.Create.CodingKeys.role)
                try container.encode(self.paymentMethod, forKey: User.Create.CodingKeys.paymentMethod)
            } catch {
                throw .encodingFailure
            }
        }
        
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
