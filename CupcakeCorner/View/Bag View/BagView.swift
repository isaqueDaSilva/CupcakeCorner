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
            }
            .navigationTitle("Bag")
        }
    }
}

#Preview {
    BagView()
}

extension BagView {
    @ViewBuilder
    func BagViewPopulated() -> some View {
        List {
            
        }
    }
}

extension BagView {
    @ViewBuilder
    func BagViewEmpty() -> some View {
        List {
            
        }
    }
}
