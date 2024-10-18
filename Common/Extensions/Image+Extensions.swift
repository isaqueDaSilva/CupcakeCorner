//
//  Image+Extensions.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import SwiftUI

extension Image {
    /// Creates an Image by image's binary data representation.
    init(by imageData: Data) {
        let uiImage = UIImage(data: imageData)
        if let uiImage {
            self.init(uiImage: uiImage)
        } else {
            self.init(systemName: Icon.questionmarkDiamond.rawValue)
        }
    }
}
