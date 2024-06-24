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
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.black)
    }
}

extension View {
    /// Makes the current text highlighted as header text.
    func headerSessionText() -> some View {
        self.modifier(HeaderSessionText())
    }
}
