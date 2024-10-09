//
//  CoverImageView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/30/24.
//

import SwiftUI

struct CoverImageView: View {
    var coverImage: Image?
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Group {
            if let coverImage {
                coverImage
                    .resizable()
                    .scaledToFit()
            } else {
                Icon.squareSlash.systemImage
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    init(
        coverImage: Image? = nil,
        width: CGFloat = 150,
        height: CGFloat = 150
    ) {
        self.coverImage = coverImage
        self.width = width
        self.height = height
    }
}

#Preview {
    CoverImageView()
}
