//
//  BuyView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct CupcakeView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var cacheStorage: CacheStorageService
    @StateObject var viewModel = ViewModel()
    
    let colums: [GridItem] = [.init(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .load, .faliedToLoad:
                    CupcakeViewLoad()
                case .loading:
                    ProgressView()
                }
            }
            #if CLIENT
            .navigationTitle("Buy")
            #elseif ADMIN
            .navigationTitle("Cupcakes")
            .toolbar {
                Button {
                    viewModel.showingCreateNewCupcakeView = true
                } label: {
                    Icon.plusCircle.systemImage
                }
            }
            .sheet(isPresented: $viewModel.showingCreateNewCupcakeView) {
                CreateCupcakeView()
            }
            #endif
            .onChange(of: scenePhase) { oldValue , newValue in
                if (oldValue == .inactive) && (newValue == .active) {
                    getCupcakes()
                }
                
                if newValue == .inactive {
                    viewModel.task?.cancel()
                    viewModel.task = nil
                }
            }
            .refreshable {
                getCupcakes()
            }
            .alert(
                viewModel.error?.title ?? "No Title",
                isPresented: $viewModel.showingError
            ) {
            } message: {
                Text(viewModel.error?.description ?? "No Description")
            }
            .navigationDestination(for: Cupcake.Get.self) { cupcake in
                #if CLIENT
                OrderView(cupcake: cupcake)
                #elseif ADMIN
                CupcakeDetailView(cupcake: cupcake)
                #endif
            }
            .environmentObject(cacheStorage)
        }
    }
}

extension CupcakeView {
    func getCupcakes() {
        viewModel.getCupcakes { cupcakes in
            try cacheStorage.addNewCupcakes(cupcakes)
        }
    }
}

#Preview {
    CupcakeView()
        .environmentObject(CacheStorageService(inMemoryOnly: true))
}
