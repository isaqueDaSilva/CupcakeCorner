//
//  Dictionary+Extension.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/27/24.
//

import Foundation

extension Dictionary where Value: DataModel {
    var valuesArray: [Value] { Array(values) }
}
