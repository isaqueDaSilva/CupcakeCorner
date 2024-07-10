//
//  ActionButton.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 06/04/24.
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
    
    private var disabledState: Bool {
        (viewState == .loading || viewState == .faliedToLoad) || (isDisabled)
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Group {
                switch viewState {
                case .load, .faliedToLoad:
                    Text(label)
                        .bold()
                case .loading:
                    ProgressView()
                }
            }
            .frame(maxWidth: width)
            .frame(height: height, alignment: .center)
        }
        .disabled(disabledState)
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
        
        ActionButton(viewState: .constant(.loading), label: "Action", width: .infinity) { }
            .padding()
    }
}
