//
//  SwiftDataError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

enum PersistenceDataError: Error, LocalizedError {
    case notFound
    case noData
    case duplicateItem
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            NSLocalizedString("Item not found in persistence store.", comment: "")
        case .noData:
            NSLocalizedString("No Data was found for continue the task.", comment: "")
        case .duplicateItem:
            NSLocalizedString("You cannot save two items with the same name. Try again.", comment: "")
        }
    }
}
