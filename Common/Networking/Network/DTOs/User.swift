//
//  User.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

extension User {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case password = "password"
        case confirmPassword = "confirmPassword"
        case role = "role"
        case paymentMethod = "payment_method"
        case fullAdress = "full_adress"
        case city = "city"
        case zip = "zip"
    }
}

extension User {
    struct Get: Codable {
        let id: UUID
        let name: String
        let email: String
        let role: Role
        let paymentMethod: PaymentMethod
        let fullAdress: String?
        let city: String?
        let zip: String?
    }
}

extension User {
    struct Create: Encodable {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
        let role: Role
        var paymentMethod: PaymentMethod
        var fullAdress: String?
        var city: String?
        var zip: String?
        
        init(
            name: String,
            email: String,
            password: String,
            confirmPassword: String,
            role: Role,
            paymentMethod: PaymentMethod,
            fullAdress: String? = nil,
            city: String? = nil,
            zip: String? = nil
        ) {
            self.name = name
            self.email = email
            self.password = password
            self.confirmPassword = confirmPassword
            self.role = role
            self.paymentMethod = paymentMethod
            self.fullAdress = fullAdress
            self.city = city
            self.zip = zip
        }
    }
}

extension User {
    struct Update: Encodable {
        let name: String?
        let fullAdress: String?
        let city: String?
        let zip: String?
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.name, forKey: CodingKeys.name)
            try container.encodeIfPresent(self.fullAdress, forKey: CodingKeys.fullAdress)
            try container.encodeIfPresent(self.city, forKey: CodingKeys.city)
            try container.encodeIfPresent(self.zip, forKey: CodingKeys.zip)
        }
    }
}
