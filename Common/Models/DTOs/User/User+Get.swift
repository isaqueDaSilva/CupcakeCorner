//
//  User+Get.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation

extension User {
    struct Get: DataResponse {
        let id: UUID
        let name: String
        let email: String
        let role: Role
        let paymentMethod: PaymentMethod
    }
}
