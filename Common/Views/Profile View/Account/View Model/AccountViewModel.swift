//
//  AccountViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

extension AccountView {
    final class ViewModel: ObservableObject {
        var user: User?
        
        @Published var buttonViewState: ViewState = .load
        @Published var signOutViewState: ViewState = .load
        @Published var viewState: ViewState = .loading
        
        let persistenceStore: SwiftDataService<User>
        
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
        
        private func getUser() throws -> User {
            let usersLoad = try persistenceStore.get()
            
            guard let user = usersLoad.first else {
                throw SwiftDataError.notFound
            }
            
            return user
        }
        
        func logout(_ completation: @escaping () -> Void) {
            Task {
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
                    
                    if let user {
                        try persistenceStore.delete(user)
                    } else {
                        throw SwiftDataError.noData
                    }
                    
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
        
        init(inMemoryOnly: Bool = false) {
            persistenceStore = SwiftDataService<User>(inMemoryOnly: inMemoryOnly)
            do {
                self.user = try getUser()
                viewState = .load
            } catch let error {
                self.error = AppAlert(title: "Falied to Load an User", description: error.localizedDescription)
                showingError = true
            }
        }
    }
}
