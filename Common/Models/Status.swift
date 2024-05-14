//
//  Status.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 23/04/24.
//

import Foundation

enum Status: String, Codable, CaseIterable, Identifiable {
    case inBag, ordered, outForDelivery, delivered, canceled
    
    var id: Self { self }
}
