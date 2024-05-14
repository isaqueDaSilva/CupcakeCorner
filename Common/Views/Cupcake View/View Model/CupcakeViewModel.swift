//
//  BuyViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation

extension CupcakeView {
    final class ViewModel: ObservableObject {
        @Published var cupcakes = [Cupcake.Get]()
        @Published var viewState: ViewState = .loading
        @Published var showingError = false
        @Published var error: AppAlert?
        @Published var task: Task<Void, Never>? = nil
        
        #if ADMIN
        @Published var showingCreateNewCupcakeView = false
        #endif
        
        var newestCupcake: Cupcake.Get? { cupcakes.min { $0.createdAt < $1.createdAt } }
        
        func getCupcakes(
            _ cacheCupcakes: @escaping (Cupcake.Get) -> Void,
            loadCupcakes: @escaping () throws -> [Cupcake.Get]
        ) {
            task = Task {
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
                        cacheCupcakes(cupcakeResult)
                    }
                    
                    try await MainActor.run {
                        cupcakes = try loadCupcakes
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
                let samples = Cupcake.sampleCupcakes
                
                for sample in samples {
                    try? persistenceStore.create(new: sample)
                }
                
                let getCupcakes = try? persistenceStore.get()
                _cupcakes = Published(initialValue: getCupcakes ?? [])
            } else {
                getCupcakes()
            }
        }
    }
}
