//
//  EditCupcake.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 02/05/24.
//

import SwiftUI
import PhotosUI

struct EditCupcake: View {
    @Environment(\.dismiss) private var dismiss
    
    let navigationTitle: String
    let coverImage: Image?
    
    @Binding var pickerItemSelected: PhotosPickerItem?
    @Binding var flavorName: String
    @Binding var price: Double
    @Binding var ingredients: [String]
    @Binding var viewState: ViewState
    var action: (@escaping () -> Void) -> Void
    
    @State private var ingredientName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack {
                        CoverImageView(coverImage: coverImage)
                        
                        PhotosPicker(
                            "Select an Cover",
                            selection: $pickerItemSelected
                        )
                        .buttonStyle(BorderedProminentButtonStyle())
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Section("Informations:") {
                    TextField(
                        "Insert the flavor name here...",
                        text: $flavorName
                    )
                    
                    TextField(
                        "Insert the price here...",
                        value: $price,
                        format: .currency(
                            code: "USD"
                        )
                    )
                    .keyboardType(.decimalPad)
                }
                
                Section("Ingredients:") {
                    ForEach(ingredients, id: \.self) {
                        Text($0)
                    } 
                    .onDelete { indexSet in
                        ingredients.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField(
                            "Insert a ingredient here...",
                            text: $ingredientName
                        )
                        
                        Button{
                            withAnimation {
                                ingredients.append(ingredientName)
                                ingredientName = ""
                            }
                        } label: {
                            Icon.plusCircle.systemImage
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Icon.chevronLeft.systemImage
                            Text("Back")
                        }
                    }

                }
                
                ToolbarItem(placement: .confirmationAction) {
                    
                    ActionButton(
                        viewState: $viewState,
                        label: "OK"
                    ) {
                        action {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EditCupcake(
        navigationTitle: "Create",
        coverImage: nil, 
        pickerItemSelected: .constant(nil),
        flavorName: .constant(""),
        price: .constant(0), 
        ingredients: .constant([]), 
        viewState: .constant(.load)
    ) { _ in }
}
