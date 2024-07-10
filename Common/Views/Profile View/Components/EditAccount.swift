//
//  EditAccount.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 05/06/24.
//

import SwiftUI

struct EditAccount: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var paymentMethod: PaymentMethod
    
    @Binding var viewState: ViewState
    
    private var isDisabled: Bool
    private let buttonLabel: String
    private var action: () -> Void
    
    var body: some View {
        Form {
            Section("User Information") {
                LabeledContent("Name:") {
                    TextField("Insert your name here...", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
                if !isDisabled {
                    LabeledContent("Email:") {
                        TextField("Insert your email here...", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    LabeledContent("Password:") {
                        SecureField("Create a Password", text: $password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .multilineTextAlignment(.trailing)
                            
                    }
                    
                    LabeledContent("Confirm:") {
                        SecureField("Confirm your password", text: $confirmPassword)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                #if CLIENT
                LabeledContent("Payment Method") {
                    Picker("Payment Method", selection: $paymentMethod) {
                        ForEach(PaymentMethod.allCases, id: \.id) { method in
                            PaymentMethodSelector(method)
                        }
                    }
                    .labelsHidden()
                }
                #endif
            }
            
            Section {
                ActionButton(
                    viewState: $viewState,
                    label: buttonLabel,
                    width: .infinity
                ) {
                    action()
                }
            }
            .listSectionSpacing(.compact)
            .listRowBackground(Color.clear)
        }
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

#Preview {
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

#Preview {
    EditAccount(
        name: .constant("Tim Cook"),
        paymentMethod: .constant(.cash),
        viewState: .constant(.load),
        buttonLabel: "Update",
        isDisabled: true
    ) { }
}
