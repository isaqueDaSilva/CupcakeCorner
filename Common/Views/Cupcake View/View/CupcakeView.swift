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
            .onAppear {
                getCupcakes()
            }
            .onChange(of: scenePhase) { oldValue , newValue in
                if newValue == .inactive {
                    viewModel.task?.cancel()
                    viewModel.task = nil
                }
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
        } loadCupcakes: {
            cacheStorage.storage[0].cupcakes
        }
    }
}

#Preview {
    CupcakeView()
        .environmentObject(CacheStorageService(inMemoryOnly: true))
}
