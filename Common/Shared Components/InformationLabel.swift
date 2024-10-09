//
//  InformationLabel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/28/24.
//

import SwiftUI

/// Displays the subtotal information.
struct InformationLabel: View {
    let title: String
    let subtotal: Double
    
    var body: some View {
        LabeledContent(title, value: subtotal.currency)
    }
    
    init(
        _ subtotal: Double,
        title: String = "Subtotal:"
    ) {
        self.title = title
        self.subtotal = subtotal
    }
}
