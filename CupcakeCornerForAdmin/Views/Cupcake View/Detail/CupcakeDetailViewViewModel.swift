//
//  CupcakeViewModel.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import Foundation
import SwiftData

extension CupcakeDetailView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var showingEditView = false
        @Published var viewState: ViewState = .load
        @Published var showingAlert = false
        
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        func showingConfirmation() {
            alertTitle = "Delete Cupcake"
            alertMessage = "Are you sure you want to delete this cupcake?"
            showingAlert = true
        }
        
        func deleteCupcake(
            with cupcake: Cupcake,
            and modelContext: ModelContext,
            _ completation: @escaping (UUID) -> Void
        ) {
            Task(priority: .background) {
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    try await CupcakeDeleteSender.deleteCupcakeReq(with: cupcake.id)
                    modelContext.delete(cupcake)
                    try modelContext.save()
                    
                    await MainActor.run {
                        viewState = .load
                        completation(cupcake.id)
                    }
                } catch let error {
                    await MainActor.run {
                        self.alertTitle = "Falied to Delete Cupcake."
                        self.alertMessage = error.localizedDescription
                        viewState = .load
                        showingAlert = true
                    }
                }
            }
        }
    }
}
