//
//  EditCupcake.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/3/24.
//


import SwiftUI
import PhotosUI

struct EditCupcake: View {
    @Binding var pickerItemSelected: PhotosPickerItem?
    @Binding var flavorName: String
    @Binding var price: Double
    @Binding var ingredients: [String]
    @Binding var viewState: ViewState
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.itsAnIPadDevice) private var itsAnIpadDevice
    
    @FocusState private var focusedField: FocusedField?
    
    @State private var ingredientName = ""
    
    let navigationTitle: String
    let coverImage: Image?
    
    var action: (@escaping () -> Void) -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    CoverImageView(coverImage: coverImage)
                    
                    PhotosPicker(
                        "Select an Cover",
                        selection: $pickerItemSelected
                    )
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.bottom)
                    
                    
                    Text("Cupcake Information:")
                        .headerSessionText(
                            font: itsAnIpadDevice ? .title3.bold() : .headline,
                            color: .secondary
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    insertFlavorField
                    
                    priceField
                    
                    ingredientsField
                        .overlay {
                            Button{
                                addIngredient()
                            } label: {
                                Icon.plusCircle.systemImage
                            }
                            .buttonStyle(.plain)
                            .padding(.trailing, 5)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .onSubmit(of: .text) {
                            addIngredient()
                        }
                        .padding(.bottom)
                    
                    if !ingredients.isEmpty {
                        IngredientsList(
                            ingredients: $ingredients,
                            itsAnIpadDevice: itsAnIpadDevice
                        )
                    }
                }
                .padding()
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
                        if flavorName.isEmpty {
                            focusedField = .flavorName
                        } else if price < 1 {
                            focusedField = .price
                        } else if ingredients.isEmpty {
                            focusedField = .ingredients
                        } else {
                            action {
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension EditCupcake {
    enum FocusedField: Hashable {
        case flavorName
        case price
        case ingredients
    }
}

extension EditCupcake {
    @ViewBuilder
    private var insertFlavorField: some View {
        TextFieldFocused(
            focusedField: $focusedField,
            focusedFieldValue: .flavorName,
            fieldType: .textField(
                "Insert flavor name here...",
                $flavorName
            ),
            inputAutocapitalization: .sentences
        )
    }
}

extension EditCupcake {
    @ViewBuilder
    private var priceField: some View {
        TextFieldFocused(
            focusedField: $focusedField,
            focusedFieldValue: .price,
            fieldType: .textField(
                "Insert the price here...",
                Binding(get: {
                    price.currency
                }, set: { newValue in
                    var newPrice = newValue
                    let range = String.Index(
                        utf16Offset: 2,
                        in: newPrice)
                    newPrice.removeSubrange(..<range)
                    price = (newPrice as NSString).doubleValue
                })
            ),
            keyboardType: .decimalPad,
            inputAutocapitalization: .sentences
        )
    }
}

extension EditCupcake {
    private func addIngredient() {
        withAnimation {
            guard !ingredientName.isEmpty else { return }
            ingredients.append(ingredientName)
            ingredientName = ""
        }
    }
    
    @ViewBuilder
    private var ingredientsField: some View {
        TextFieldFocused(
            focusedField: $focusedField,
            focusedFieldValue: .ingredients,
            fieldType: .textField(
                "Insert a new Ingredient here...",
                $ingredientName
            ),
            inputAutocapitalization: .sentences
        )
    }
}

#Preview {
    EditCupcake(
        pickerItemSelected: .constant(nil),
        flavorName: .constant(""),
        price: .constant(0),
        ingredients: .constant(["One", "Two"]),
        viewState: .constant(.load),
        navigationTitle: "Create",
        coverImage: nil
    ) { _ in }
}
