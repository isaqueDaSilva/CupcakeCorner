//
//  Status.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 23/04/24.
//

import Foundation

/// A representation of the order status.
enum Status: String, Codable, CaseIterable, Identifiable, Sendable {
    case inBag, ordered, outForDelivery, delivered
    
    var id: Self { self }
    
    var displayedName: String {
        switch self {
        case .ordered:
            "Ordered"
        case .outForDelivery:
            "Out for Delivery"
        case .delivered:
            "Delivered"
        default:
            "Non Text for Display"
        }
    }
}
