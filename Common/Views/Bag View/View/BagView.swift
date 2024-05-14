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
            }
            .onChange(of: scenePhase) { oldValue, newValue in
                if (oldValue == .inactive || oldValue == .background) && newValue == .active {
                    if cacheStorage.storage[0].user != nil {
                        viewModel.connect()
                    }
                }
                
                if (newValue == .background) {
                    viewModel.disconnect()
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
        }
    }
}

#Preview {
    BagView()
        .environmentObject(CacheStorageService(inMemoryOnly: true))
}
