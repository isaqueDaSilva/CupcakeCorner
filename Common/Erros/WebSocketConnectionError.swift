//
//  WebSocketConnectionError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation

extension BagView {
    /// An representation of the errors that may be occur on a operation of the WebSocket .
    enum WebSocketConnectionError: Error, LocalizedError, Sendable {
        
        /// This error is for time when the encoding model is failied.
        case encodingError
        
        /// This error is for time when the decoding data is failied.
        case decodingError
        
        /// This error is for time when the unknown error is find.
        case unknownError(Error)
        
        /// This error is for time when the connection is lost.
        case noConnection
        
        /// Indicate that some failure when receiving data from the Web Socket.
        case receiveDataFailed
        
        /// Indicates that the data what is receive is not supported by the app.
        case dataNotSuported
        
        case disconected
        
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
            case .receiveDataFailed, .dataNotSuported:
                NSLocalizedString("Failed to receive data, try again or contact us.", comment: "")
            default: ""
            }
        }
    }
}
