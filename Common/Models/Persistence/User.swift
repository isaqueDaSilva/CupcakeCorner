//
//  User.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 08/07/24.
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
    var paymentMethod: PaymentMethod
    
    private init(
        id: UUID,
        name: String,
        email: String,
        role: Role,
        paymentMethod: PaymentMethod
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.paymentMethod = paymentMethod
    }
}

extension User {
    convenience init(from result: Get) {
        self.init(
            id: result.id,
            name: result.name,
            email: result.email,
            role: result.role,
            paymentMethod: result.paymentMethod
        )
    }
}

extension User {
    func update(from result: Get) {
        if result.name != name {
            name = result.name
        }
        
        if result.paymentMethod != paymentMethod {
            paymentMethod = result.paymentMethod
        }
    }
}

extension User {
    static var sampleUser: User {
        let newUser = User(
            id: .init(),
            name: "Tim Cook",
            email: "timcook@apple.com",
            role: .client,
            paymentMethod: .debitCard
        )
        
        return newUser
    }
}
