//
//  ActionButton.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/28/24.
//

import SwiftUI

/// A default app button style.
struct ActionButton: View {
    @Binding var viewState: ViewState
    
    let label: String
    
    let width: CGFloat?
    let height: CGFloat?
    
    let isDisabled: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Group {
                switch viewState {
                case .load, .faliedToLoad:
                    VStack {
                        Text(label)
                            .bold()
                    }
                case .loading:
                    VStack {
                        ProgressView()
                    }
                    .frame(height: height, alignment: .center)
                    
                }
            }
            .frame(maxWidth: width)
            .frame(height: height, alignment: .center)
        }
        .disabled(isDisabled)
        .buttonStyle(.borderedProminent)
    }
    
    init(
        viewState: Binding<ViewState>,
        label: String,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        _viewState = viewState
        self.label = label
        self.action = action
        self.width = width
        self.height = height
        self.isDisabled = isDisabled
    }
}

#Preview {
    VStack {
        ActionButton(viewState: .constant(.load), label: "Action") { }
            .padding()
        
        ActionButton(viewState: .constant(.loading), label: "Action", width: .infinity, isDisabled: true) { }
            .padding()
    }
}
