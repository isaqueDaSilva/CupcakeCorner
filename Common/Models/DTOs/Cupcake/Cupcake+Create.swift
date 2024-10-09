//
//  User+Create.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//


import Foundation

extension Cupcake {
    /// A representation of the data that used for create a cupcake.
    struct Create: Encodable, Sendable {
        var flavor: String
        var coverImage: Data
        var ingredients: [String]
        var price: Double
    }
}
