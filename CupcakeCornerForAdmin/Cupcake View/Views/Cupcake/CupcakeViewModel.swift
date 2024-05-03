//
//  CupcakeViewModel.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import Foundation
import SwiftUI

extension CupcakeDetailView {
    final class ViewModel: ObservableObject {
        let cupcake: Cupcake
        let persistenceStore: SwiftDataService<Cupcake>
        
        @Published var showingEditView = false
        @Published var viewState: ViewState = .load
        @Published var showingError = false
        @Published var alert: AppAlert?
        
        var coverImage: UIImage? {
            let imageData = cupcake.coverImage
            
            return UIImage(data: imageData)
        }
        
        func showingConfirmation() {
            alert = AppAlert(
                title: "Delete Cupcake",
                description: "Are you sure you want to delete this cupcake?"
            )
            
            showingError = true
        }
        
        func deleteCupcake(_ completationHandler: @escaping () -> Void) {
            Task {
                do {
                    await MainActor.run {
                        viewState = .loading
                    }
                    
                    let tokenValue = try KeychainService.retrive()
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/cupcake/delete/\(cupcake.id)",
                        values: [.init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization)],
                        httpMethod: .delete,
                        type: .getData
                    )
                    
                    let (_, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    try persistenceStore.delete(cupcake)
                    
                    await MainActor.run {
                        viewState = .load
                        completationHandler()
                    }
                } catch let error {
                    await MainActor.run {
                        self.alert = AppAlert(title: "Falied to Delete Cupcake.", description: error.localizedDescription)
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init(cupcake: Cupcake, inMemoryOnly: Bool = false) {
            self.cupcake = cupcake
            
            persistenceStore = SwiftDataService<Cupcake>(inMemoryOnly: inMemoryOnly)
        }
    }
}
