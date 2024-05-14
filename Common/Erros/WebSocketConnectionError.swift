//
//  WebSocketConnectionError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation

enum WebSocketConnectionError: Error {
    case encodingError
    case decodingError
    case unknownError(Error)
}
