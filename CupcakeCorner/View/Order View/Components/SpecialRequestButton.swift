//
//  SpecialRequestButton.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 07/04/24.
//

import SwiftUI

extension OrderView {
    struct SpecialRequestButton: View {
        @Binding var isActive: Bool
        let requestName: String
        
        var body: some View {
            Button {
                withAnimation(.spring) {
                    isActive.toggle()
                }
            } label: {
                GroupBox {
                    LabeledContent(requestName, value: "\(isActive ? "-" : "+") \(Double(5).currency)")
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .fill(isActive ? .blue : Color(uiColor: .systemGray6))
                }
            }
        }
    }
}
