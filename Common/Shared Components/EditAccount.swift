//
//  EditAccount.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//

import SwiftUI

struct EditAccount: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var paymentMethod: PaymentMethod
    
    @Binding var viewState: ViewState
    
    @FocusState private var focusedField: FocusedField?
    
    private var isDisabled: Bool
    private let buttonLabel: String
    private var action: () -> Void
    
    var body: some View {
        ScrollView {
            Text("User Information:")
                .headerSessionText(
                    font: .headline,
                    color: .secondary
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            
            #if os(iOS)
            TextFieldFocused(
                focusedField: $focusedField,
                focusedFieldValue: .name,
                fieldType: .textField(
                    "Insert your name here...",
                    $name
                ),
                inputAutocapitalization: .sentences
            )
            #elseif os(macOS)
            TextFieldFocused(
                focusedField: $focusedField,
                focusedFieldValue: .name,
                fieldType: .textField(
                    "Insert your name here...",
                    $name
                )
            )
            #endif
            
            if !isDisabled {
                #if os(iOS)
                TextFieldFocused(
                    focusedField: $focusedField,
                    focusedFieldValue: .email,
                    fieldType: .textField(
                        "Insert your email here...",
                        $email
                    ),
                    keyboardType: .emailAddress,
                    isAutocorrectionDisabled: true
                )
                
                TextFieldFocused(
                    focusedField: $focusedField,
                    focusedFieldValue: .password,
                    fieldType: .secureField(
                        "Creates a password here...",
                        $password
                    ),
                    isAutocorrectionDisabled: true
                )
                
                TextFieldFocused(
                    focusedField: $focusedField,
                    focusedFieldValue: .confirmPassword,
                    fieldType: .secureField(
                        "Confirm your password here...",
                        $confirmPassword
                    ),
                    isAutocorrectionDisabled: true
                )
                #elseif os(macOS)
                TextFieldFocused(
                    focusedField: $focusedField,
                    focusedFieldValue: .email,
                    fieldType: .textField(
                        "Insert your email here...",
                        $email
                    ),
                    isAutocorrectionDisabled: true
                )
                
                TextFieldFocused(
                    focusedField: $focusedField,
                    focusedFieldValue: .password,
                    fieldType: .secureField(
                        "Creates a password here...",
                        $password
                    ),
                    isAutocorrectionDisabled: true
                )
                
                TextFieldFocused(
                    focusedField: $focusedField,
                    focusedFieldValue: .confirmPassword,
                    fieldType: .secureField(
                        "Confirm your password here...",
                        $confirmPassword
                    ),
                    isAutocorrectionDisabled: true
                )
                #endif
            }
            
            #if CLIENT
            VStack {
                Text("Payment Method:")
                    .headerSessionText(
                        font: .headline,
                        color: .secondary
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                Picker("Payment Method", selection: $paymentMethod) {
                    ForEach(PaymentMethod.allCases, id: \.id) { method in
                        Text(method.displayedName)
                            .tag(method.id)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .padding(.top, 5)
            .padding(.bottom)
            #endif
            
            ActionButton(
                viewState: $viewState,
                label: buttonLabel,
                width: .infinity
            ) {
                if name.isEmpty {
                    focusedField = .name
                } else if email.isEmpty && !isDisabled {
                    focusedField = .email
                } else if password.isEmpty && !isDisabled {
                    focusedField = .password
                } else if confirmPassword.isEmpty && !isDisabled {
                    focusedField = .confirmPassword
                } else {
                    action()
                }
            }
        }
        .padding(.horizontal)
        #if os(macOS)
        .padding(.top, 5)
        #endif
    }
    
    init(
        name: Binding<String>,
        email: Binding<String> = .constant(""),
        password: Binding<String> = .constant(""),
        confirmPassword: Binding<String> = .constant(""),
        paymentMethod: Binding<PaymentMethod>,
        viewState: Binding<ViewState>,
        buttonLabel: String,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        _name = name
        _email = email
        _password = password
        _confirmPassword = confirmPassword
        _paymentMethod = paymentMethod
        _viewState = viewState
        self.buttonLabel = buttonLabel
        self.isDisabled = isDisabled
        self.action = action
    }
}

extension EditAccount {
    enum FocusedField: Hashable {
        case name, email, password, confirmPassword
    }
}

#Preview {
    NavigationStack {
        EditAccount(
            name: .constant(""),
            email: .constant(""),
            password: .constant(""),
            confirmPassword: .constant(""),
            paymentMethod: .constant(.cash),
            viewState: .constant(.load),
            buttonLabel: "Create"
        ) { }
    }
}

#Preview {
    EditAccount(
        name: .constant("Tim Cook"),
        paymentMethod: .constant(.cash),
        viewState: .constant(.load),
        buttonLabel: "Update",
        isDisabled: true
    ) { }
}
