//
//  DataResponse.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

protocol DataResponse: Codable, Sendable, Equatable {
    var id: UUID { get }
}
