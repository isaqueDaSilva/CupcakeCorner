//
//  DataModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation
import SwiftData

protocol DataModel where Self: PersistentModel {
    associatedtype Result: Codable
    
    var id: UUID { get }
    static func create(from result: Result) -> Self
    func update(from result: Result) -> Self
}
