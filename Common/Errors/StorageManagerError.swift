//
//  StorageManagerError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

extension StorageManager {
    enum StorageManagerError: Error, LocalizedError {
        case invalidModelContainer
        case noModelContext
        case fetchFailed
        case saveFailed
        case insertFailed
        case unknownModelType
        case modelQuantityDifferent
        case deleteFail
        
        var errorDescription: String? {
            switch self {
            case .invalidModelContainer:
                return "Invalid container setup."
            case .noModelContext:
                return "No model context available to peform this action."
            case .fetchFailed:
                return "Failed to fetch data."
            case .saveFailed:
                return "Failed to save data."
            case .insertFailed:
                return "Failed to insert data."
            case .unknownModelType:
                return "Unknown data type was returned after this operation."
            case .modelQuantityDifferent:
                return "The model quantity is different than expected."
            case .deleteFail:
                return "Failed to delete model from storage."
            }
        }
    }
}
