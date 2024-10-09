//
//  IngredientCell.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/3/24.
//


import SwiftUI

struct IngredientCell: View {
    private let ingredient: String
    private let isLastIngredient: Bool
    
    var body: some View {
        VStack {
            Text(ingredient)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !isLastIngredient {
                Divider()
            }
        }
    }
    
    init(for ingredient: String, isLastIngredient: Bool) {
        self.ingredient = ingredient
        self.isLastIngredient = isLastIngredient
    }
}

#Preview {
    IngredientCell(for: "Chocolate", isLastIngredient: false)
        .padding()
}