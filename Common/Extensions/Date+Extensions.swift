//
//  Date+Extensions.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/06/24.
//

import Foundation

extension Date {
    /// Transforms the date in a string representation.
    var dateString: String {
        let formatter = DateFormatter()
        let currentLocale = Locale.current
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = currentLocale
        
        return formatter.string(from: self)
    }
}
