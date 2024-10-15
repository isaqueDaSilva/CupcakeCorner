//
//  CupcakeView+ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/30/24.
//

import Foundation

extension CupcakeView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .loading
        @Published var showingAlert = false
        @Published var alert = AlertHandler()
        
        private let inMemoryOnly: Bool
        
        func fetchCupcakes(
            with isCupcakeListEmpty: Bool,
            _ completation: @escaping @Sendable (([Cupcake.Get]) async throws -> Void),
            failureComletation: @escaping @Sendable () async throws -> Void
        ) {
            Task {
                do {
                    if viewState != .loading {
                        await MainActor.run {
                            viewState = .loading
                        }
                    }
                    
                    let authorizationKey = try TokenGetter.getValue()
                    let fetchedCupcaked = try await Getter.get(authorizationKey: authorizationKey)
                    
                    try await completation(fetchedCupcaked)
                    
                    await MainActor.run {
                        viewState = .load
                    }
                } catch {
                    try await failureComletation()
                    
                    await MainActor.run {
                        alert.setAlert(
                            with: "Fetch Cupcake Failed",
                            and: error.localizedDescription
                        )
                        
                        showingAlert = true
                        
                        viewState = .faliedToLoad
                    }
                }
            }
        }
        
        init(inMemoryOnly: Bool = false) {
            self.inMemoryOnly = inMemoryOnly
        }
        
        deinit {
            print("CupcakeView+ViewModel was deinitialized.")
        }
    }
}
