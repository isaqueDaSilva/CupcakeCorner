//
//  CacheStorage.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 07/05/24.
//

import Foundation
import SwiftData

@Model
final class CacheStorage {
    let id = UUID()
    var user: User.Get?
    var cupcakes: [Cupcake.Get]
    
    init(
        user: User.Get? = nil,
        cupcakes: [Cupcake.Get] = []
    ) {
        self.user = user
        self.cupcakes = cupcakes
    }
}
