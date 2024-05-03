//
//  BuyViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation

extension BuyView {
    final class ViewModel: ObservableObject {
        @Published var cupcakes = [Cupcake]()
        @Published var viewState: ViewState = .loading
        @Published var showingError = false
        @Published var error: AppAlert?
        @Published var showingProfileView = false
        
        let persistenceStore: SwiftDataService<Cupcake>
        
        var newestCupcake: Cupcake? { cupcakes.min { $0.createdAt < $1.createdAt } }
        
        func getCupcakes() {
            Task {
                do {
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
                    
                    let cupcakesResults = try decoder.decode([Cupcake.Get].self, from: data)
                    
                    for cupcakeResult in cupcakesResults {
                        let cupcake = Cupcake(from: cupcakeResult)
                        try persistenceStore.create(new: cupcake)
                    }
                    
                    try await MainActor.run {
                        cupcakes = try persistenceStore.get()
                        viewState = .load
                    }
                    
                } catch let error {
                    await MainActor.run {
                        self.error = AppAlert(title: "Falied to load Cupcakes", description: error.localizedDescription)
                        viewState = .faliedToLoad
                        showingError = true
                    }
                }
            }
        }
        
        init(inMemoryOnly: Bool = false) {
            persistenceStore = SwiftDataService<Cupcake>(inMemoryOnly: inMemoryOnly)
            
            if inMemoryOnly {
                _cupcakes = Published(initialValue: [])
            } else {
                getCupcakes()
            }
        }
    }
}
