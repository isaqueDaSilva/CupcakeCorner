//
//  BagViewEmpty.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
//

import SwiftUI

extension BagView {
    @ViewBuilder
    func BagViewEmpty(with description: BagViewTexts = .contentUnavaiableDescription) -> some View {
        VStack {
            ContentUnavailableView(
                BagViewTexts.contentUnavaiableTitle.rawValue,
                systemImage: Icon.bag.rawValue,
                description: Text(description.rawValue)
            )
        }
    }
}

#Preview {
    BagView().BagViewEmpty()
}
