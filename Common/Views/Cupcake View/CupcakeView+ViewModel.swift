//
//  CupcakeView+ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 25/04/24.
//

import Foundation
import SwiftData
import SwiftUI

extension CupcakeView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var cupcakes = [Cupcake]()
        @Published var viewState: ViewState = .loading
        @Published var showingError = false
        @Published var errorTitle = ""
        @Published var errorDescription = ""
        
        #if ADMIN
        @Published var showingCreateNewCupcakeView = false
        #endif
        
        private var inMemoryOnly: Bool
        
        #if CLIENT
        var newestCupcake: Cupcake?
        #endif
        
        func loadCupcakes(with isUserLogged: Bool, and modelContext: ModelContext) {
            Task {
                do {
                    #if ADMIN
                    guard isUserLogged else {
                        return await MainActor.run {
                            displayError(title: "You are not connected")
                        }
                    }
                    #endif
                    
                    if viewState != .loading {
                        await MainActor.run {
                            viewState = .loading
                        }
                    }
                    
                    if !inMemoryOnly {
                        let newCupcakes = try await CupcakeGetter.get()
                        
                        try CupcakeCacher.caching(newCupcakes, with: modelContext)
                    }
                    
                    try await MainActor.run {
                        try fetchAllCupcakes(with: modelContext)
                    }
                } catch {
                    await MainActor.run {
                        displayError(title: "Failed to load cupcakes", error: error, and: modelContext)
                    }
                }
            }
        }
        
        private func fetchAllCupcakes(with modelContext: ModelContext) throws {
            let descriptor = FetchDescriptor<Cupcake>()
            let cupcakes = try modelContext.fetch(descriptor)
            
            self.cupcakes = cupcakes
            
            #if CLIENT
            self.newestCupcake = cupcakes.min(by: { $0.createAt > $1.createAt })
            #endif
            
            if self.viewState == .loading {
                self.viewState = .load
            }
        }
        
        #if ADMIN
        func insertNewCupcake(with cupcake: Cupcake) {
            self.cupcakes.insert(cupcake, at: 0)
        }
        
        func deleteCupcake(by id: UUID) {
            do {
                let index = self.cupcakes.firstIndex(where: { $0.id == id })
                
                guard let index else { throw CacheStoreError.notFound }
                
                self.cupcakes.remove(at: index)
            } catch {
                displayError(title: "Failed to delete cupcake.", error: error)
            }
        }
        
        func deleteAllCupcakes(with context: ModelContext) {
            do {
                for cupcake in cupcakes {
                    context.delete(cupcake)
                }
                
                try context.save()
                
                self.cupcakes = []
            } catch {
                displayError(title: "Failed to delete Cupcakes", error: CacheStoreError.deleteError)
            }
        }
        #endif
        
        func displayError(
            title: String,
            error: Error? = nil,
            and modelContext: ModelContext? = nil
        ) {
            self.errorTitle = title
            
            if let error {
                self.errorDescription = error.localizedDescription
            }
            
            if cupcakes.isEmpty {
                if let modelContext {
                    do {
                        try fetchAllCupcakes(with: modelContext)
                    } catch {
                        self.cupcakes = []
                    }
                }
            }
            
            showingError = true
            
            self.viewState = .load
        }
        
        #if ADMIN
        func openCreateNewCupcakeView() {
            showingCreateNewCupcakeView = true
        }
        #endif
        
        init(inMemoryOnly: Bool = false) {
            self.inMemoryOnly = inMemoryOnly
        }
        
        deinit {
            print("CupcakeView+ViewModel was deinitialized.")
        }
    }
}
