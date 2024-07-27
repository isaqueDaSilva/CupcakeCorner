//
//  CacheStoreError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 27/06/24.
//

import Foundation

enum CacheStoreError: Error, LocalizedError {
    case notFound
    case inseringError
    case loadingFailed
    case updateFailed
    case deleteError
    case fetchActionFailed
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            NSLocalizedString("No item found. Please try again", comment: "")
        case .updateFailed:
            NSLocalizedString("Failed to update data in the store. Try again or contact us.", comment: "")
        case .fetchActionFailed:
            NSLocalizedString("There is some error occur when the fetch action was executing.\n Try reload the page or contact us if this error persit.", comment: "")
        case .inseringError:
            NSLocalizedString("It wasn't possible to insert a new item in the list.\n Try reload the page.", comment: "")
        case .loadingFailed:
            NSLocalizedString("Failed to load the items list.\n Try reload the page or contact us if this error persit.", comment: "")
        case .deleteError:
            NSLocalizedString("Failed to delete item. Try again or contact us", comment: "")
        }
    }
}
