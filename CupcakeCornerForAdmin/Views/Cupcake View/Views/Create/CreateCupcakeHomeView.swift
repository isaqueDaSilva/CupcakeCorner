//
//  CreateCupcakeHomeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 02/05/24.
//

import Foundation
import SwiftUI
import PhotosUI

extension CreateCupcakeView {
    final class ViewModel: ObservableObject {
        @Published var cupcake: Cupcake.Create
        @Published var viewState: ViewState = .load
        
        @Published var pickerItemSelected: PhotosPickerItem? = nil {
            didSet {
                if let pickerItemSelected {
                    getImage(pickerItemSelected)
                }
            }
        }
        
        @Published var coverImage: UIImage? = nil
        
        @Published var showingError = false
        @Published var error: AppAlert?
        
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
        
        func create(
            _ completationHandler: @escaping () -> Void,
            createCupcake: @escaping (Cupcake.Get) throws -> Void
        ) {
            task = Task(priority: .background) {
                do {
                    await MainActor.run {
                        viewState = .loading
                    }
                    
                    let encoder = JSONEncoder()
                    let cupcakeData = try encoder.encode(cupcake)
                    
                    let tokenValue = try KeychainService.retrive()
                    let bearerValue = AuthorizationHeader.bearer.rawValue
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/cupcake/create",
                        values: [
                            .init(value: "\(bearerValue) \(tokenValue)", httpHeaderField: .authorization),
                            .init(value: "application/json", httpHeaderField: .contentType)
                        ],
                        httpMethod: .post,
                        type: .uploadData(cupcakeData)
                    )
                    
                    let (data, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    let decoder = JSONDecoder()
                    let newCupcake = try decoder.decode(Cupcake.Get.self, from: data)
                    
                    try createCupcake(newCupcake)
                    
                    await MainActor.run {
                        completationHandler()
                        viewState = .load
                    }
                } catch let error {
                    await MainActor.run {
                        self.error = AppAlert(title: "Falied to Create Cupcake", description: error.localizedDescription)
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init() {
            _cupcake = Published(
                initialValue: .init(
                    coverImage: .init(),
                    flavor: "",
                    ingredients: [],
                    price: 0
                )
            )
        }
    }
}
