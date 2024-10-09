//
//  Status.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

/// A representation of the order status.
enum Status: String, Codable, CaseIterable, Identifiable, Sendable {
    case ordered, readyForDelivery, delivered
    
    var id: Self { self }
    
    var displayedName: String {
        switch self {
        case .ordered:
            "Ordered"
        case .readyForDelivery:
            "Ready For Delivery"
        case .delivered:
            "Delivered"
        }
    }
    
    static var allCases: [Status] {
        [.ordered, .readyForDelivery]
    }
    
    static var allStatusCase: [Status] {
        [.ordered, .readyForDelivery, .delivered]
    }
}
