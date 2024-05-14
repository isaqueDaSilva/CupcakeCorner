//
//  NewCupcakeHighlights.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/04/24.
//

import SwiftUI

extension CupcakeView {
    struct NewCupcakeHighlights<Destination: View>: View {
        let name: String
        let description: String
        let cover: Image
        let price: Double
        
        var destination: () -> Destination
        
        var body: some View {
            GroupBox {
                cover
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom)
                
                HStack {
                    Text("From \(price.currency)")
                        .font(.subheadline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    NavigationLink {
                        destination()
                    } label: {
                        Text("Buy")
                            .foregroundStyle(.blue)
                            .padding([.top, .bottom], 2)
                            .padding(.horizontal, 10)
                            .background(
                                Capsule()
                                    .fill(.black.opacity(0.1))
                            )
                    }
                }
            } label: {
                Text(name)
                
                Text("Made with \(description)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        
        init(
            name: String,
            description: [String],
            cover data: Data,
            price: Double,
            @ViewBuilder destination: @escaping () -> Destination
        ) {
            self.name = name
            self.description = description.joined(separator: ", ")
            self.price = price
            
            let uiImage = UIImage(data: data)
            
            self.cover = (uiImage != nil) ? Image(uiImage: uiImage!) : Icon.questionmarkDiamond.systemImage
            
            self.destination = destination
        }
    }
}
//#Preview {
//    let image = UIImage(systemName: Icon.house.rawValue)
//    let imageData = image?.pngData()
//    
//    return CupcakeView.NewCupcakeHighlights(name: "Name", description: ["Some", "Description"], cover: imageData!, price: 10) { }
//}
