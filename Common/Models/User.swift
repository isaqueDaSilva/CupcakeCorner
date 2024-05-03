//
//  User.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable {
    let id: UUID
    var name: String
    let email: String
    var role: Role
    var paymentMethod: PaymentMethod
    var bag: [UUID]
    var favorites: [UUID]
    var street: String?
    var city: String?
    var zip: String?
    
    init(
        id: UUID,
        name: String,
        email: String,
        role: Role,
        paymentMethod: PaymentMethod,
        bag: [UUID],
        favorites: [UUID],
        street: String? = nil,
        city: String? = nil,
        zip: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.paymentMethod = paymentMethod
        self.bag = bag
        self.favorites = favorites
        self.street = street
        self.city = city
        self.zip = zip
    }
    
    convenience init(from userPublic: UserPublic) {
        self.init(
            id: userPublic.id,
            name: userPublic.name,
            email: userPublic.email,
            role: userPublic.role,
            paymentMethod: userPublic.paymentMethod,
            bag: userPublic.bag,
            favorites: userPublic.favorites,
            street: userPublic.street,
            city: userPublic.city,
            zip: userPublic.zip
        )
    }
}
