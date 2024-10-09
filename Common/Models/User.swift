//
//  User.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation
import SwiftData

@Model
final class User {
    #Unique<User>([\.id, \.name])
    #Index<User>([\.id])
    
    var id: UUID
    var name: String
    var email: String
    var role: Role
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

extension User: DataModel {
    typealias RelationshipModel = User
    typealias Result = Get
    
    static func create(from result: Get) -> Self {
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
    func update(from result: Get) -> Self {
        if result.name != name {
            name = result.name
        }
        
        if result.paymentMethod != paymentMethod {
            paymentMethod = result.paymentMethod
        }
        
        return self
    }
}

// MARK: - Sample -
extension User {
    static func makeSampleUser(in context: ModelContext) throws {
        let newUser = User(
            id: .init(),
            name: "Tim Cook",
            email: "timcook@apple.com",
            role: .client,
            paymentMethod: .debitCard
        )
        
        context.insert(newUser)
        try context.save()
    }
}
