//
//  BagView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct BagView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject private var cacheStorage: CacheStorageService
    
    @State private var accessPageCount = 0
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .load:
                    if !viewModel.orders.isEmpty {
                        BagViewPopulated()
                    } else {
                        BagViewEmpty()
                    }
                case .loading:
                    ProgressView()
                case .faliedToLoad:
                    BagViewEmpty(with: .error)
                }
            }
            #if CLIENT
            .navigationTitle("Bag")
            #elseif ADMIN
            .navigationTitle("Client Orders")
            #endif
            .onAppear {
                viewModel.setClientID(
                    clientID: cacheStorage.storage[0].user?.id
                )
                
                if cacheStorage.storage[0].user != nil {
                    accessPageCount += 1
                    if accessPageCount == 1 {
                        viewModel.connect()
                    }
                } else {
                    viewModel.viewState = .load
                }
            }
            .onChange(of: scenePhase) { _, newValue in
                if (newValue == .background) {
                    viewModel.disconnect()
                    accessPageCount = 0
                }
            }
            #if CLIENT
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    InformationLabel(
                        viewModel.totalOfTheBag,
                        title: "Total of this bag"
                    )
                }
            }
            #endif
            .appErrorAlert($viewModel.showingAlert, error: viewModel.alert) { }
        }
    }
}

#Preview {
    BagView()
        .environmentObject(CacheStorageService(inMemoryOnly: true))
}
