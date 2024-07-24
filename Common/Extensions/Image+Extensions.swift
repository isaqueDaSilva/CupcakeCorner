//
//  Image+Extensions.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 19/07/24.
//

import SwiftUI

extension Image {
    /// Creates an Image by data.
    init(by imageData: Data) {
        let uiImage = UIImage(data: imageData)
        if let uiImage {
            self.init(uiImage: uiImage)
        } else {
            self.init(systemName: Icon.questionmarkDiamond.rawValue)
        }
    }
}
