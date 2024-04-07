//
//  ActionButton.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
//

import SwiftUI

struct ActionButton: View {
    let label: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ActionButton(label: "Action") { }
        .padding()
}
