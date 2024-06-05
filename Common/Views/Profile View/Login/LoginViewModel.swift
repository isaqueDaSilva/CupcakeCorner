//
//  LoginViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 18/04/24.
//

import Foundation

extension LoginView {
    /// An object that discrible how the CupcakeView handle with some action.
    final class ViewModel: ObservableObject {
        /// Stores the Login model.
        @Published var loginCredentials: Login
        
        /// Stores the current view state for the sign in button.
        @Published var viewState: ViewState = .load
        
        /// Stores the current value for the error.
        ///
        /// If no error occur, the value is false, and if occur the value is true
        @Published var showingError = false
        
        /// Stores an instance of the custum wrapper error.
        @Published var error: AppAlert?
        
        /// Stores an Task instance for indicates
        /// if is possible to execute an asynchronous task.
        var task: Task<Void, Never>? = nil
        
        /// Stores the cache store instance.
        private let cacheStore: CacheStoreService
        
        /// Performing the login action.
        func login() {
            task = Task(priority: .background) {
                do {
                    // Changes the state of the Login button
                    // to indicate to the user that the login action
                    // is being performed
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    // Gets the token and bearer value for pass into HTTP header field
                    let tokenValue = try await loginCredentials.getTokenValue()
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    // Creates a new intance of the Network Service
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/user/get",
                        values: [.init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization)],
                        httpMethod: .get,
                        type: .getData
                    )
                    
                    // Run the newtork service
                    let (data, response) = try await request.run()
                    
                    // Checks if the response received from the request is equal to 200
                    // if no equal, throws an error indicating that an error occur.
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                            throw APIError.accessDenied
                        } else {
                            throw APIError.badResponse
                        }
                    }
                    
                    // Decoding a data in a User.Get model
                    let decoder = JSONDecoder()
                    let userGetted = try decoder.decode(User.Get.self, from: data)
                    
                    // loads the user saved on the persistence store
                    let userSaved = try await cacheStore.fetchWithRequest(
                        for: User.self,
                        with: "User"
                    )
                    
                    // Check whether the persistence store is empty,
                    // if it is not empty, a persistence store cleanup action
                    // will be performed.
                    if !userSaved.isEmpty {
                        for user in userSaved {
                            try await cacheStore.delete(user)
                        }
                    }
                    
                    // Getting the current context for use it for save a new user.
                    let context = await cacheStore.getContext()
                    
                    // creating a new User and save it on persistence store.
                    let newUser = User(context: context)
                    newUser.id = userGetted.id
                    newUser.name = userGetted.name
                    newUser.email = userGetted.email
                    newUser.role = userGetted.role.rawValue
                    newUser.paymentMethod = userGetted.paymentMethod.rawValue
                    newUser.fullAdress = userGetted.fullAdress
                    newUser.city = userGetted.city
                    newUser.zip = userGetted.zip
                    
                    try await cacheStore.save()
                    
                    // Changing the view state of the login button again
                    // for indicating that the login action is finished
                    // and in a few moments, the user will be redirect to the profile view.
                    await MainActor.run {
                        self.viewState = .load
                    }
                } catch let error {
                    // If an error occurs, the task will be interrupted,
                    // redirecting execution to the catch block,
                    // where the error will be displayed.
                    await MainActor.run {
                        self.error = AppAlert(title: "Login Falied", description: error.localizedDescription)
                        self.viewState = .load
                        self.showingError = true
                    }
                }
            }
        }
        
        init(inMemoryOnly: Bool = false) {
            _loginCredentials = Published(initialValue: .init(email: "", password: ""))
            self.cacheStore = inMemoryOnly ? .preview : .shared
        }
    }
}
