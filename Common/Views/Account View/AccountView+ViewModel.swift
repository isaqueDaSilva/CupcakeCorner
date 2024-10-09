//
//  ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//


import Foundation
import KeychainService
import NetworkHandler
import SwiftData

extension AccountView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var signOutViewState: ViewState = .load
        @Published var deleteAccountViewState: ViewState = .load
        @Published var showingAlert = false
        @Published var alert = AlertHandler()
        
        var isErrorShowing = false
        var isDeleteAccountAction = false
        
        var isDisabled: Bool {
            (signOutViewState == .loading) || (deleteAccountViewState == .loading)
        }
        
        func deleteAction(
            with completation: @escaping () async throws -> Void
        ) {
            Task {
                let deleteType: DeleteType = isDeleteAccountAction ? .user : .token
                do {
                    await MainActor.run {
                        self.signOutViewState = .loading
                    }
                    
                    let authenticationValue = try TokenGetter.getValue()
                    
                    try await Deleter.makeDelete(with: authenticationValue, for: deleteType)
                    
                    _ = try KeychainService.delete()
                    
                    try await completation()
                    
                    await MainActor.run {
                        self.signOutViewState = .load
                    }
                } catch let error {
                    isErrorShowing = true
                    await MainActor.run {
                        displayAlert(
                            with: (deleteType == .token) ? "Logout Failed" : "Delete Account Failed",
                            and: error.localizedDescription
                        )
                    }
                }
            }
        }
        
        func makeAction(with completation: @escaping @Sendable () async throws -> Void) {
            Task {
                do {
                    try await completation()
                } catch {
                    displayAlert(with: "Unknow fail", and: error.localizedDescription)
                }
            }
        }
        
        func displayAlert(
            with title: String,
            and description: String = "No User avaiable to make this action."
        ) {
            alert.setAlert(
                with: title,
                and: description
            )
            signOutViewState = .load
            showingAlert = true
        }
        
        deinit {
            print("AccountView+ViewModel was deinitialized.")
        }
    }
}

extension AccountView {
    enum DeleteType: String {
        case user = "delete"
        case token = "logout"
    }
}
