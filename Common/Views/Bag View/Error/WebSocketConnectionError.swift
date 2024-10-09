//
//  WebSocketConnectionError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//


import Foundation

extension BagView {
    /// An representation of the errors that may be occur on a operation of the WebSocket .
    enum WebSocketConnectionError: Error, LocalizedError, Sendable {
        
        /// This error is for time when the encoding model is failied.
        case encodingError
        
        /// This error is for time when the connection is lost.
        case noConnection
        
        /// Indicate that some failure when receiving data from the Web Socket.
        case receiveDataFailed
        
        var errorDescription: String? {
            switch self {
            case .encodingError:
                NSLocalizedString("Failed to encode order for sending.", comment: "")
            case .noConnection:
                NSLocalizedString("Failed to establish a connection with the server. try again or contact us.", comment: "")
            case .receiveDataFailed:
                NSLocalizedString("Failed to receive data, try again or contact us.", comment: "")
            }
        }
    }
}