//
//  PaymentMethod.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

/// A representation of an user's payment method.
enum PaymentMethod: String, Codable, CaseIterable, Identifiable, Sendable {
    case cash, creditCard, debitCard, isAdmin
    
    var id: Self { self }
    
    var displayedName: String {
        switch self {
        case .cash:
            "Cash"
        case .creditCard:
            "Credit Card"
        case .debitCard:
            "Debit Crad"
        case .isAdmin:
            ""
        }
    }
    
    static var allCases: [PaymentMethod] {
        [.cash, .creditCard, .debitCard]
    }
}
