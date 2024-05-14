//
//  Values.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 24/04/24.
//

import Foundation

extension NetworkService {
    struct Values {
        let value: String
        let httpHeaderField: String
        
        init(value: String, httpHeaderField: HTTPHeaderField) {
            self.value = value
            self.httpHeaderField = httpHeaderField.rawValue
        }
    }
}
