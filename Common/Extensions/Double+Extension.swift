//
//  Double+Extension.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import Foundation

extension Double {
    /// Converts the current Double value into currency String.
    var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter.string(for: self) ?? "Unable to perform conversion."
    }
}
