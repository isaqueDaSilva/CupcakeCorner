//
//  AppError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

/// A representation of the error issued by the app, to be used to display an alert.
struct AppAlert {
    /// The title of the error that was occured.
    let title: String
    
    /// The description of the error that was occured.
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
