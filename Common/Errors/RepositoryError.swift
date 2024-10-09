//
//  RepositoryError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

enum RepositoryError: Error, LocalizedError {
    case noItem
    case invalidQuantity
    case invalidInsertion
    
    var errorDescription: String? {
        switch self {
        case .noItem:
            "No item is available to perform the requested action."
        case.invalidQuantity:
            "Quantity of items is different than expected.\nSeams that are no items available or has duplicates."
        case .invalidInsertion:
            "It looks like an error occurred when data was being saved to persistent storage."
        }
    }
}
