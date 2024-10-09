//
//  AlertHandler.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/28/24.
//

import Foundation

struct AlertHandler {
    var title = ""
    var message = ""
    
    mutating func setAlert(with title: String, and message: String) {
        self.title = title
        self.message = message
    }
}
