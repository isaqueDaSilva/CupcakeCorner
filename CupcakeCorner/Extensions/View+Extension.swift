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
    func headerSessionText() -> some View {
        self.modifier(HeaderSessionText())
    }
}
