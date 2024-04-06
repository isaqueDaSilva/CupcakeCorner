//
//  BagView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct BagView: View {
    var body: some View {
        NavigationStack {
            Group {
                BagViewPopulated()
                //BagViewEmpty()
            }
            .navigationTitle("Bag")
        }
    }
}

#Preview {
    BagView()
}
