//
//  AppError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation
import SwiftUI

struct AppAlert<A: View>: ViewModifier {
    @Binding var isPresented: Bool
    let error: AppErrorProtocol?
    @ViewBuilder var action: () -> A
    
    func body(content: Content) -> some View {
        content
            .alert(error?.title ?? "No Title", isPresented: $isPresented) {
                action()
            } message: {
                Text(error?.description ?? "No Description")
            }
    }
}

extension View {
    func appErrorAlert<A: View>(
        _ isPresented: Binding<Bool>,
        error: AppErrorProtocol?,
        @ViewBuilder actions: @escaping () -> A
    ) -> some View {
        self
            .modifier(
                AppAlert<A>(
                    isPresented: isPresented,
                    error: error,
                    action: actions
                )
            )
    }
}
