//
//  ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/6/24.
//


import Foundation
import SwiftData
import KeychainService

extension LoginView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var loginCredentials: Login
        @Published var viewState: ViewState = .load
        @Published var showingError = false
        @Published var alert = AlertHandler()
        
        func login(
            with urlSession: URLSession = .shared,
            and completation: @escaping (User.Get) async throws -> Void
        ) {
           Task {
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    let loginResponse = try await loginCredentials.makeLogin(with: urlSession)
                    
                    _ = try KeychainService.store(for: loginResponse.jwtToken)
                    
                    try await completation(loginResponse.userProfile)
                    
                    await MainActor.run {
                        self.viewState = .load
                    }
                } catch let error {
                    await MainActor.run {
                        self.alert.setAlert(
                            with: "Login Falied",
                            and: error.localizedDescription
                        )
                        self.viewState = .load
                        self.showingError = true
                    }
                }
            }
        }
        
        init() {
            _loginCredentials = Published(initialValue: .init(email: "", password: ""))
        }
        
        deinit {
            print("LoginView+ViewModel was deinitialized.")
        }
    }
}
