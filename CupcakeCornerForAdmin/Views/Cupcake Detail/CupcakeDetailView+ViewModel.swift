//
//  CupcakeDetailView+ViewModel.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 10/3/24.
//

import Foundation
import NetworkHandler

extension CupcakeDetailView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .load
        @Published var showingAlert = false
        @Published var alert = AlertHandler()
        
        var isErrorShowing = false
        
        func showingConfirmation() {
            alert.setAlert(
                with: "Delete Cupcake",
                and: "Are you sure you want to delete this cupcake?"
            )
            showingAlert = true
        }
        
        func deleteCupcake(
            with cupcakeID: UUID?,
            _ completation: @escaping @Sendable () async throws -> Void
        ) {
            Task {
                do {
                    guard let cupcakeID else {
                        throw NetworkService.APIError.fieldsEmpty
                    }
                    
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    try await DeleteSender.delete(with: cupcakeID)
                    
                    try await completation()
                    
                    await MainActor.run {
                        viewState = .load
                    }
                } catch let error {
                    await MainActor.run {
                        alert.setAlert(
                            with: "Falied to Delete Cupcake.",
                            and: error.localizedDescription
                        )
                        
                        viewState = .load
                        isErrorShowing = true
                        showingAlert = true
                    }
                }
            }
        }
    }
}
