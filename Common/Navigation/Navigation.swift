//
//  Navigation.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 19/04/24.
//

import SwiftUI

@Observable
final class Navigation {
    var path = [Bool]()
    
    func append(_ value: Bool) {
        path.append(value)
    }
    
    func remove() {
        path.removeLast()
    }
}
