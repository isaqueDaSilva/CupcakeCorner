//
//  AccountViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import CoreData
import Foundation

extension AccountView {
    /// An object that discrible how the CupcakeView handle with some action.
    final class ViewModel: ObservableObject {
        /// Stores an instance of the user logged.
        var user: User
        
        /// Stores the current value sign button view state.
        @Published var signOutViewState: ViewState = .load
        
        /// Stores the current value for the error.
        ///
        /// If no error occur, the value is false, and if occur the value is true.
        @Published var showingError = false
        
        /// Stores an instance of the custum wrapper error.
        @Published var error: AppAlert?
        
        /// Stores an instance of the CacheStoreService
        private let cacheStore: CacheStoreService
        
        /// Stores an instance of the Task.
        var task: Task<Void, Never>? = nil
        
        /// User name
        var name: String {
            user.wrappedName
        }
        
        /// User email
        var email: String {
            user.wrappedEmail
        }
        
        /// User main adress
        var mainShipping: String {
            user.wrappedAdress
        }
        
        /// User main payment.
        var mainPayment: String {
            user.wrappedPaymentMethod
        }
        
        /// Performing a logout action.
        func logout() {
            task = Task(priority: .background) {
                do {
                    // Changing the current state
                    // of the sign out button for
                    // loading state.
                    await MainActor.run {
                        self.signOutViewState = .loading
                    }
                    // Gets the token and bearer value.
                    let tokenValue = try KeychainService.retrive()
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    // Creates a new instance of the Network Service.
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/user/logout",
                        values: [.init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization)],
                        httpMethod: .delete,
                        type: .getData
                    )
                    
                    // Perform the action.
                    let (_, response) = try await request.run()
                    
                    // Checks if the response status code is equal to 200.
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    // Deleting the token value in the Keychain
                    _ = try KeychainService.delete()
                    
                    // Deleting the user from the Core Data.
                    try await cacheStore.delete(user)
                    
                    // Changing the current state
                    // of the sign out button for
                    // load state again.
                    await MainActor.run {
                        self.signOutViewState = .load
                    }
                } catch let error {
                    // If some error is occur, will be
                    // redirect for the catch block
                    // and populated the error property.
                    await MainActor.run {
                        self.error = AppAlert(title: "Logout Falied", description: error.localizedDescription)
                        signOutViewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init(user: User, inMemoryOnly: Bool = false) {
            self.cacheStore = inMemoryOnly ? .sharedInMemoryOnly : .shared
            self.user = user
        }
    }
}
