//
//  PaymentMethodSelector.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/05/24.
//

import SwiftUI

struct PaymentMethodSelector: View {
    let method: PaymentMethod
    
    var body: some View {
        if method != .isAdmin {
            Text(method.displayedName)
                .tag(method.id)
        }
    }
    
    init(_ method: PaymentMethod) {
        self.method = method
    }
}

#Preview {
    PaymentMethodSelector(.cash)
}
