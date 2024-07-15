//
//  AccountViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation
import SwiftData

extension AccountView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var signOutViewState: ViewState = .load
        @Published var deleteAccountViewState: ViewState = .load
        @Published var showingAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        var isDeleteAccountAction = false
        
        func logout(
            with user: User,
            and context: ModelContext,
            _ completation: @escaping () -> Void
        ) {
            Task(priority: .background) {
                do {
                    await MainActor.run {
                        self.signOutViewState = .loading
                    }
                    
                    let authenticationValue = try Authentication.value()
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/user/logout",
                        values: [.init(value: authenticationValue, httpHeaderField: .authorization)],
                        httpMethod: .delete,
                        type: .getData
                    )
                    
                    let (_, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    _ = try KeychainService.delete()
                    
                    context.delete(user)
                    
                    await MainActor.run {
                        completation()
                        self.signOutViewState = .load
                    }
                } catch let error {
                    await MainActor.run {
                       displayError(with: error)
                    }
                }
            }
        }
        
        func showingDeleteAccountAlert() {
            alertTitle = "Delete Account"
            alertMessage = "Are you sure in delete your account?"
            isDeleteAccountAction = true
            showingAlert = true
        }
        
        func deleteAccount(
            with user: User,
            and context: ModelContext,
            _ completation: @escaping () -> Void
        ) {
            Task(priority: .background) {
                do {
                    await MainActor.run {
                        self.signOutViewState = .loading
                    }
                    
                    let authenticationValue = try Authentication.value()
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/user/delete",
                        values: [.init(value: authenticationValue, httpHeaderField: .authorization)],
                        httpMethod: .delete,
                        type: .getData
                    )
                    
                    let (_, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    _ = try KeychainService.delete()
                    
                    context.delete(user)
                    
                    await MainActor.run {
                        completation()
                        self.signOutViewState = .load
                    }
                } catch let error {
                    await MainActor.run {
                       displayError(with: error)
                    }
                }
            }
        }
        
        func displayError(with error: Error? = nil) {
            alertTitle = "Logout Falied"
            alertMessage = error?.localizedDescription ?? "No User avaiable to make this action."
            signOutViewState = .load
            showingAlert = true
        }
        
        deinit {
            print("AccountView+ViewModel was deinitialized.")
        }
    }
}
