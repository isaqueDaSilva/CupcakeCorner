//
//  CreateCupcakeView+ViewModel.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
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
        @Published var alert = AlertHandler()
        
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
        
        func create(
            with completationHandler: @escaping (Cupcake.Get) async throws -> Void,
            dismissScreen: @escaping () -> Void
        ) {
            Task {
                do {
                    await MainActor.run {
                        self.viewState = .loading
                    }
                    
                    let newCupcake = try await Creater.create(with: cupcake)
                    
                    await MainActor.run {
                        self.viewState = .load
                    }
                    
                    try await completationHandler(newCupcake)
                    
                    await MainActor.run {
                        self.viewState = .load
                        dismissScreen()
                    }
                } catch let error {
                    await MainActor.run {
                        alert.setAlert(
                            with: "Falied to Create Cupcake",
                            and: error.localizedDescription
                        )
                        viewState = .load
                        showingError = true
                    }
                }
            }
        }
        
        init() {
            _cupcake = Published(
                initialValue: .init(
                    flavor: "",
                    coverImage: .init(),
                    ingredients: [],
                    price: 0
                )
            )
        }
    }
}
