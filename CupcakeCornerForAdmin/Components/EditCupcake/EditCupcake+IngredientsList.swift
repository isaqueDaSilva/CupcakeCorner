//
//  EditCupcake+IngredientsList.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/3/24.
//


import SwiftUI

extension EditCupcake {
    struct IngredientsList: View {
        @Binding var ingredients: [String]
        private let itsAnIpadDevice: Bool
        
        var body: some View {
            VStack {
                Text("Ingredients:")
                    .font(itsAnIpadDevice ? .headline : nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .padding(.bottom, 5)
                
                ForEach(ingredients, id: \.self) { ingredient in
                    HStack {
                        IngredientCell(
                            for: ingredient,
                            isLastIngredient: ingredient == ingredients.last
                        )
                        
                        Button {
                            guard let index = ingredients.firstIndex(of: ingredient) else { return }
                            
                            return withAnimation {
                                ingredients.remove(at: index)
                            }
                        } label: {
                            Icon.trash.systemImage
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
        
        init(ingredients: Binding<[String]>, itsAnIpadDevice: Bool) {
            _ingredients = ingredients
            self.itsAnIpadDevice = itsAnIpadDevice
        }
    }
}

#Preview {
    EditCupcake.IngredientsList(ingredients: .constant(["One", "Two"]), itsAnIpadDevice: true)
        .padding()
}
