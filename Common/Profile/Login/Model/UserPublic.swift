//
//  UserPublic.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

struct UserPublic: Decodable {
    let id: UUID
    let name: String
    let email: String
    let role: Role
    let paymentMethod: PaymentMethod
    let bag: [UUID]
    let favorites: [UUID]
    let street: String?
    let city: String?
    let zip: String?
}
