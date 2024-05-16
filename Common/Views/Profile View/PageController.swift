//
//  PageController.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 21/04/24.
//

import Foundation
import SwiftUI

final class PageController: ObservableObject {
    @Published var isAuthorized = false
    
    private let key = Keys.authorized.rawValue
    
    func setNewValue(_ isAuthorizedStatus: Bool) {
        UserDefaults.standard.set(isAuthorizedStatus, forKey: key)
        isAuthorized = isAuthorizedStatus
    }
    
    func getCurrentValue() {
        isAuthorized = UserDefaults.standard.bool(forKey: key)
    }
    
    init() {
        getCurrentValue()
    }
}
