//
//  AccountViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

extension AccountView {
    final class ViewModel: ObservableObject {
        var user: User.Get?
        
        @Published var buttonViewState: ViewState = .load
        @Published var signOutViewState: ViewState = .load
        @Published var viewState: ViewState = .loading
        @Published var task: Task<Void, Never>? = nil
        
        var showingError = false
        var error: AppAlert?
        
        var name: String {
            user?.name ?? "No name..."
        }
        
        var email: String {
            user?.email ?? "No email..."
        }
        
        var mainShipping: String {
            "\(user?.fullAdress ?? "No Street"), \(user?.city ?? "No city"), \(user?.zip ?? "No ZIP code")"
        }
        
        var mainPayment: String {
            user?.paymentMethod.displayedName ?? "Payment method not identified."
        }
        
        func setUser(user: User.Get?) {
            do {
                if let user {
                    self.user = user
                    viewState = .load
                } else {
                    throw PersistenceDataError.noData
                }
            } catch {
                self.error = AppAlert(title: "Falied To Set User", description: error.localizedDescription)
                signOutViewState = .load
                showingError = true
            }
        }
        
        func logout(
            _ completation: @escaping () -> Void,
            deleteUserCached: @escaping () throws -> Void
        ) {
            task = Task(priority: .background) {
                do {
                    await MainActor.run {
                        signOutViewState = .loading
                    }
                    
                    let tokenValue = try KeychainService.retrive()
                    
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/user/logout",
                        values: [.init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization)],
                        httpMethod: .delete,
                        type: .getData
                    )
                    
                    let (_, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    try deleteUserCached()
                    
                    _ = try KeychainService.delete()
                    
                    await MainActor.run {
                        signOutViewState = .load
                        completation()
                    }
                } catch {
                    await MainActor.run {
                        self.error = AppAlert(title: "Logout Falied", description: error.localizedDescription)
                        signOutViewState = .load
                        showingError = true
                    }
                }
            }
        }
    }
}
