//
//  CupcakeCard.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

extension BuyView {
    struct CupcakeCard: View {
        let name: String
        let image: Image
        
        var body: some View {
            GroupBox(name) {
                image
                    .resizable()
                    .scaledToFit()
            }
        }
        
        init(
            name: String,
            imageData: Data
        ) {
            self.name = name
            
            let uiImage = UIImage(data: imageData)
            
            self.image = (uiImage != nil) ? Image(uiImage: uiImage!) : Icon.questionmarkDiamond.systemImage
        }
    }
}
//
//#Preview {
//    BuyView.CupcakeCard(name: "Dummy Name", image: Icon.house.systemImage)
//        
//}
