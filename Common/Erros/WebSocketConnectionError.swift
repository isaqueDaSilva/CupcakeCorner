//
//  WebSocketConnectionError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation

enum WebSocketConnectionError: Error, LocalizedError {
    case encodingError
    case decodingError
    case unknownError(Error)
    case noConnection
    case wrongData
    
    var errorDescription: String? {
        switch self {
        case .encodingError:
            NSLocalizedString("Failed to encode order for sending.", comment: "")
        case .decodingError:
            NSLocalizedString("Falied to decode a data for display in the App.", comment: "")
        case .unknownError(let error):
            NSLocalizedString("An unexpected error occurred: \(error.localizedDescription)", comment: "")
        case .noConnection:
            NSLocalizedString("Failed to establish a connection with the server. try again or contact us.", comment: "")
        case .wrongData:
            NSLocalizedString("The data received it's not in the correct format for use.", comment: "")
        }
    }
}
