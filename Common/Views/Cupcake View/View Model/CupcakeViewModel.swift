//
//  CupcakeViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation

extension CupcakeView {
    final class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .loading
        @Published var showingError = false
        @Published var error: AppAlert?
        @Published var task: Task<Void, Never>? = nil
        
        #if ADMIN
        @Published var showingCreateNewCupcakeView = false
        #endif
        
        func getCupcakes(
            _ cacheCupcakes: @escaping ([Cupcake.Get]) throws -> Void
        ) {
            task = Task(priority: .background) {
                do {
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        self.viewState = .loading
                    }
                    
                    let request = NetworkService(
                        endpoint: "http://127.0.0.1:8080/api/cupcake/all",
                        httpMethod: .get,
                        type: .getData
                    )
                    
                    let (data, response) = try await request.run()
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.badResponse
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let cupcakesResults = try decoder.decode([Cupcake.Get].self, from: data)
                    
                    try cacheCupcakes(cupcakesResults)
                    
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        self.viewState = .load
                    }
                    
                } catch let error {
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        
                        self.error = AppAlert(title: "Falied to load Cupcakes", description: error.localizedDescription)
                        self.viewState = .load
                        self.showingError = true
                    }
                }
            }
        }
    }
}
