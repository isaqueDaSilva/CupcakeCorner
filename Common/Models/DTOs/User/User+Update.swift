//
//  User+Update.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//


import Foundation

extension User {
    /// A representation of the data that used for update an user..
    struct Update: Encodable, Sendable {
        let name: String?
        let paymentMethod: PaymentMethod?
    }
}
