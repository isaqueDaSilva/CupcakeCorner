//
//  TextFieldFocused.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/3/24.
//


import SwiftUI

struct TextFieldFocused<FocusedFieldValue: Hashable>: View {
    @FocusState.Binding var focusedField: FocusedFieldValue?
    
    let focusedFieldValue: FocusedFieldValue
    let field: FieldType
    let keyboardType: UIKeyboardType
    let inputAutocapitalization: TextInputAutocapitalization
    let isAutocorrectionDisabled: Bool
    
    var body: some View {
        field.makeField()
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(uiColor: .systemGray5))
            }
            .keyboardType(keyboardType)
            .textInputAutocapitalization(inputAutocapitalization)
            .autocorrectionDisabled(isAutocorrectionDisabled)
            .focused($focusedField, equals: focusedFieldValue)
    }
    
    init(
        focusedField: FocusState<FocusedFieldValue?>.Binding,
        focusedFieldValue: FocusedFieldValue,
        fieldType: FieldType,
        keyboardType: UIKeyboardType = .default,
        inputAutocapitalization: TextInputAutocapitalization = .never,
        isAutocorrectionDisabled: Bool = false
    ) {
        _focusedField = focusedField
        self.field = fieldType
        self.focusedFieldValue = focusedFieldValue
        self.keyboardType = keyboardType
        self.inputAutocapitalization = inputAutocapitalization
        self.isAutocorrectionDisabled = isAutocorrectionDisabled
    }
}

extension TextFieldFocused {
    enum FieldType {
        case textField(String, Binding<String>)
        case secureField(String, Binding<String>)
        
        @ViewBuilder
        func makeField() -> some View {
            switch self {
            case .textField(let title, let text):
                TextField(title, text: text)
            case .secureField(let title, let secureText):
                SecureField(title, text: secureText)
            }
        }
    }
}


#Preview {
    @FocusState var focus: Bool?
    
    return TextFieldFocused(
        focusedField: $focus,
        focusedFieldValue: false,
        fieldType: .textField(
            "Hello World",
            .constant("Hello world.")
        ),
        keyboardType: .emailAddress,
        inputAutocapitalization: .never,
        isAutocorrectionDisabled: true
    )
    .padding()
}

