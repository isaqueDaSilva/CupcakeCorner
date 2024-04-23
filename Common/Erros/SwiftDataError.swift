//
//  SwiftDataError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

enum SwiftDataError: Error, LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            NSLocalizedString("Item not found in persistence store.", comment: ")
        }
    }
}
