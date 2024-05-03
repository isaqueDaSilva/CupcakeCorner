//
//  BackButton.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 26/04/24.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Icon.chevronLeft.systemImage
                Text("Back")
            }
        }
    }
}

#Preview {
    BackButton { }
}
