//
//  Double+Extension.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/27/24.
//

import Foundation

enum CurrencyFormatter {
    static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter
    }
}

extension Double {
    /// Converts the current Double value into currency String.
    var currency: String {
        CurrencyFormatter.formatter.string(for: self) ?? "Unable to perform conversion."
    }
}
