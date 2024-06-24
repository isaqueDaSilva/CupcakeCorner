//
//  Order+DTO.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 24/06/24.
//

import Foundation

extension Order {
    /// A representation of the data that used for update an order..
    struct Update: Codable, Sendable {
        var id: UUID
        var status: Status
    }
}
