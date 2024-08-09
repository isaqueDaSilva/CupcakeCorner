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
        @Published var alert = AlertHandler()
        
        func login(with context: ModelContext, _ completation: @escaping () -> Void) {
           Task(priority: .background) {
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    guard let userResult = try? await Profile.get(with: loginCredentials) else {
                        throw LoginError.unauthorized
                    }
                    let user = User(from: userResult)
                    
                    context.insert(user)
                    
                    do {
                        try context.save()
                    } catch {
                        throw CacheStoreError.inseringError
                    }
                    
                    await MainActor.run {
                        completation()
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
        
        init(inMemoryOnly: Bool = false) {
            _loginCredentials = Published(initialValue: .init(email: "", password: ""))
        }
        
        deinit {
            print("LoginView+ViewModel was deinitialized.")
        }
    }
}
