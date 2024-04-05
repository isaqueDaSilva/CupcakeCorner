//
//  Double+Extension.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import Foundation

extension Double {
    var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        return formatter.string(for: self) ?? "Unable to perform conversion."
    }
}
