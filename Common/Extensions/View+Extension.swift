//
//  View+Extension.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import Foundation
import SwiftUI

// MARK: - Header Session Text

struct HeaderSessionText: ViewModifier {
    private var font: Font
    private var fontWeight: Font.Weight
    private var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .fontWeight(fontWeight)
            .foregroundStyle(color)
    }
    
    init(font: Font, fontWeight: Font.Weight, color: Color) {
        self.font = font
        self.fontWeight = fontWeight
        self.color = color
    }
}

extension View {
    /// Makes the current text highlighted as header text.
    func headerSessionText(
        font: Font = .title2,
        fontWeight: Font.Weight = .bold,
        color: Color = .primary
    ) -> some View {
        self.modifier(
            HeaderSessionText(
                font: font,
                fontWeight: fontWeight,
                color: color
            )
        )
    }
}

#Preview{
    Text("Hello Wolrd")
        .headerSessionText(font: .headline, color: .gray)
}
