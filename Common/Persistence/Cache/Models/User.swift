//
//  User.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 24/05/24.
//
//

import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique)
    let id: UUID
    
    @Attribute(.unique)
    var name: String
    let email: String
    let role: Role
    let paymentMethod: PaymentMethod
    var fullAdress: String?
    var city: String?
    var zip: String?
    
    private init(
        id: UUID,
        name: String,
        email: String,
        role: Role,
        paymentMethod: PaymentMethod,
        fullAdress: String?,
        city: String?,
        zip: String?
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.paymentMethod = paymentMethod
        self.fullAdress = fullAdress
        self.city = city
        self.zip = zip
    }
    
    convenience init(from result: Get) {
        self.init(
            id: result.id,
            name: result.name,
            email: result.email,
            role: result.role,
            paymentMethod: result.paymentMethod,
            fullAdress: result.fullAdress,
            city: result.city,
            zip: result.zip
        )
    }
}

extension User {
    @MainActor
    static let sampleUser: User = {
        let user = User(
            id: .init(),
            name: "Tim Cook",
            email: "timcook@apple.com",
            role: .admin,
            paymentMethod: .creditCard,
            fullAdress: "One Apple Park Way",
            city: "Cupertino",
            zip: "CA 95014"
        )
        
        return user
    }()
}
