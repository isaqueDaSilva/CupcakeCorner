//
//  CancelButton.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftUI

struct CancelButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(role: .cancel) {
            action()
        } label: {
            Text("Cancel")
        }
    }
}

#Preview {
    CancelButton { }
}
