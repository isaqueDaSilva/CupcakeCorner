//
//  Cupcake+Get.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

extension Cupcake {
    /// A cupcake's data representation for decoding data that coming from the API request when is finished.
    struct Get: DataResponse {
        let id: UUID
        let flavor: String
        let coverImage: Data
        let ingredients: [String]
        let price: Double
        let createAt: Date
    }
}
