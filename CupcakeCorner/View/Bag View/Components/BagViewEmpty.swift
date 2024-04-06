//
//  BagViewEmpty.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
//

import SwiftUI

extension BagView {
    @ViewBuilder
    func BagViewEmpty() -> some View {
        ContentUnavailableView(
            BagViewTexts.contentUnavaiableTitle.rawValue,
            systemImage: Icon.bag.rawValue,
            description: Text(BagViewTexts.contentUnavaiableDescription.rawValue)
        )
    }
}

#Preview {
    BagView().BagViewEmpty()
}
