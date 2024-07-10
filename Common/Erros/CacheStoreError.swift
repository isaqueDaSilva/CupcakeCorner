//
//  CacheStoreError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 27/06/24.
//

import Foundation

enum CacheStoreError: Error, LocalizedError {
    case notFound
    case updateFailed
    case objectNonValid
    case batchInsertError
    case persistentHistoryChangeError
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            NSLocalizedString("No item found. Please try again", comment: "")
        case .updateFailed:
            NSLocalizedString("Failed to update data in the store.", comment: "")
        case .objectNonValid:
            NSLocalizedString("There is something wrong with this object that causes a failure when trying update this.", comment: "")
        case .batchInsertError:
            NSLocalizedString("Failed to execute a batch insert request.", comment: "")
        case .persistentHistoryChangeError:
            NSLocalizedString("Failed to execute a persistent history change request.", comment: "")
        }
    }
}
