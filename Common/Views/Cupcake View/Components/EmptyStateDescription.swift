//
//  EmptyStateDescription.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/07/24.
//

import Foundation

extension CupcakeView {
    var emptyStateDescription: String {
        #if CLIENT
        return "It looks like there are no cupcakes on the menu to display, please refresh the page or come back later to check out more."
        #elseif ADMIN
        return "There are no cupcakes to be displayed. This may be because you are not logged in to your account or there are no cupcakes created."
        #endif
    }
}
