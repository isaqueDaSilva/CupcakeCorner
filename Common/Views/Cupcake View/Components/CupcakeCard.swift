//
//  CupcakeCard.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

extension CupcakeView {
    struct CupcakeCard: View {
        let name: String
        let image: Image
        
        var body: some View {
            VStack {
                GroupBox(name) {
                    image
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        
        init(
            name: String,
            image: UIImage?
        ) {
            self.name = name
            
            if let image {
                self.image = Image(uiImage: image)
            } else {
                self.image = Icon.questionmarkDiamond.systemImage
            }
        }
    }
}
