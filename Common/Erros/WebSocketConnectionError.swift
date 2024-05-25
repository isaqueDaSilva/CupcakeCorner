//
//  WebSocketConnectionError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation

/// An representation of the errors that may be occur on a operation of the WebSocket .
enum WebSocketConnectionError: Error, LocalizedError {
    
    /// This error is for time when the encoding model is failied.
    case encodingError
    
    /// This error is for time when the decoding data is failied.
    case decodingError
    
    /// This error is for time when the unknown error is find.
    case unknownError(Error)
    
    /// This error is for time when the connection is lost.
    case noConnection
    
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
       }
    }
}
