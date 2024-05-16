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
                
                accessPageCount += 1
                
                if accessPageCount == 1 {
                    if cacheStorage.storage[0].user != nil {
                        viewModel.connect()
                    }
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
            .alert(
                viewModel.alert?.title ?? "No Title",
                isPresented: $viewModel.showingAlert
            ) {
            } message: {
                Text(viewModel.alert?.description ?? "No Description")
            }
        }
    }
}

#Preview {
    BagView()
        .environmentObject(CacheStorageService(inMemoryOnly: true))
}
