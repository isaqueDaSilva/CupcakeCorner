//
//  Token.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

/// A representation of a Token.
struct Token: Codable, Sendable {
    let id: UUID
    let value: String
}
