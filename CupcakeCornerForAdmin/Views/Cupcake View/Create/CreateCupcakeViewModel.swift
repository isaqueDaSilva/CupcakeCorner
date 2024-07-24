//
//  CreateCupcakeHomeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 02/05/24.
//

import Foundation
import SwiftUI
import SwiftData
import PhotosUI

extension CreateCupcakeView {
    @MainActor
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
        
        @Published var coverImage: Image? = nil
        
        @Published var showingError = false
        @Published var errorTitle = ""
        @Published var errorMessage = ""
        
        private var inMemoryOnly: Bool
        
        private func getImage(_ itemSelected: PhotosPickerItem) {
            GetPhoto.get(with: itemSelected) { [weak self] imageData in
                guard let self else { return }
                
                if let imageData {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.cupcake.coverImage = imageData
                        self.coverImage = Image(by: imageData)
                    }
                }
            }
        }
        
        /// Creating a new cupcake on database.
        /// - Parameter completationHandler: Pass an function that will be execute after the creation request is successed.
        func create(
            with context: ModelContext,
            _ completationHandler: @escaping (Cupcake) -> Void
        ) {
            Task(priority: .background) {
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    if !inMemoryOnly {
                        let cupcakeResult = try await CupcakeCreateSender.create(with: cupcake)
                        
                        let newCupcake = Cupcake(from: cupcakeResult)
                        
                        context.insert(newCupcake)
                        try context.save()
                        
                        await MainActor.run {
                            completationHandler(newCupcake)
                        }
                    }
                    
                    await MainActor.run {
                        self.viewState = .load
                    }
                } catch let error {
                    await MainActor.run {
                        self.errorTitle = "Falied to Create Cupcake"
                        self.errorMessage = error.localizedDescription
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init(
            inMemoryOnly: Bool = false
        ) {
            self.inMemoryOnly = inMemoryOnly
            
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
