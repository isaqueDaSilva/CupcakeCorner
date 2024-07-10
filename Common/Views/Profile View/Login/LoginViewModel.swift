//
//  LoginViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation
import SwiftData

extension LoginView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var loginCredentials: Login
        @Published var viewState: ViewState = .load
        @Published var showingError = false
        @Published var errorTitle = ""
        @Published var errorMessage = ""
        
        func login(with context: ModelContext, _ completation: @escaping () -> Void) {
           Task(priority: .background) {
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    let userResult = try await LoginHandler.makeLogin(with: loginCredentials)
                    let user = User(from: userResult)
                    
                    context.insert(user)
                    
                    try context.save()
                    
                    await MainActor.run {
                        completation()
                        self.viewState = .load
                    }
                } catch let error {
                    await MainActor.run {
                        self.errorTitle = "Login Falied"
                        self.errorMessage = error.localizedDescription
                        self.viewState = .load
                        self.showingError = true
                    }
                }
            }
        }
        
        init(inMemoryOnly: Bool = false) {
            _loginCredentials = Published(initialValue: .init(email: "", password: ""))
        }
        
        deinit {
            print("LoginView+ViewModel was deinitialized.")
        }
    }
}
