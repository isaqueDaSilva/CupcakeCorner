//
//  ConcurrencyFormatter.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 26/07/24.
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
