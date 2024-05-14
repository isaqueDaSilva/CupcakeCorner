//
//  UpdateCupcakeViewModel.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import Foundation
import SwiftUI
import PhotosUI

extension UpdateCupcakeView {
    final class ViewModel: ObservableObject {
        @Published var cupcake: Cupcake.Get
        
        @Published var viewState: ViewState = .load
        @Published var showingError = false
        @Published var error: AppAlert?
        
        @Published var pickerItemSelected: PhotosPickerItem? = nil {
            didSet {
                if let pickerItemSelected {
                    getImage(pickerItemSelected)
                }
            }
        }
        
        @Published var coverImage: UIImage?
        
        @Published var task: Task<Void, Never>? = nil
        
        func getImage(_ pickerItemSelected: PhotosPickerItem) {
            Task {
                let (data, image) = try await GetPhoto.getImage(pickerItemSelected)
                
                if let data, let image {
                    self.cupcake.coverImage = data
                    
                    await MainActor.run {
                        coverImage = image
                    }
                }
            }
        }
        
        func update(
            _ completationHandler: @escaping () -> Void,
            updateCupcake: @escaping (Cupcake.Get) throws -> Void
        ) {
            task = Task {
                do {
                    await MainActor.run {
                        viewState = .loading
                    }
                    
                    let updatedCupcake = Cupcake.Update(
                        coverImage: cupcake.coverImage,
                        flavor: cupcake.flavor,
                        ingredients: cupcake.ingredients,
                        price: cupcake.price
                    )
                    
                    let encoder = JSONEncoder()
                    
                    let updatedCupcakeData = try encoder.encode(updatedCupcake)
                    
                    let tokenValue = try KeychainService.retrive()
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/cupcake/update/\(cupcake.id)",
                        values: [
                            .init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization),
                            .init(value: "application/json", httpHeaderField: .contentType)
                        ],
                        httpMethod: .patch,
                        type: .uploadData(updatedCupcakeData)
                    )
                    
                    let (data, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    let decoder = JSONDecoder()
                    let cupcakeResult = try decoder.decode(Cupcake.Get.self, from: data)
                    try updateCupcake(cupcakeResult)
                    
                    await MainActor.run {
                        completationHandler()
                        viewState = .load
                    }
                } catch let error {
                    await MainActor.run {
                        self.error = AppAlert(title: "Falied to Update the Cupcake", description: error.localizedDescription)
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init(cupcake: Cupcake.Get, inMemoryOnly: Bool = false) {
            _cupcake = Published(initialValue: cupcake)
            
            let image = UIImage(data: cupcake.coverImage)
            self.coverImage = image
        }
    }
}
