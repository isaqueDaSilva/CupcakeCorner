//
//  CoverImageView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 02/05/24.
//

import SwiftUI

struct CoverImageView: View {
    var coverImage: UIImage?
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Group {
            if let coverImage {
                Image(uiImage: coverImage)
                    .resizable()
                    .scaledToFill()
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
        coverImage: UIImage? = nil,
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
