//
//  AccountViewFaliedToLoad.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import SwiftUI

extension AccountView {
    @ViewBuilder
    func AccountViewFaliedToLoad() -> some View {
        ContentUnavailableView(
            "Falied to load the Profile",
            systemImage: Icon.personSlash.rawValue,
            description: Text("An error occurred while loading the profile. Please try again or contact us.")
        )
    }
}

#Preview {
    AccountView().AccountViewFaliedToLoad()
}
