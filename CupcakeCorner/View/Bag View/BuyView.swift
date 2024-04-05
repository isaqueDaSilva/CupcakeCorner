//
//  BuyView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct BuyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Icon.shippingBox.systemImage
                            .font(.largeTitle)
                        
                        VStack {
                            Text("")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Home")
        }
    }
}

#Preview {
    BuyView()
}
