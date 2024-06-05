//
//  BagView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct BagView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var viewModel: ViewModel
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .load:
                    if !viewModel.orders.isEmpty {
                        BagViewPopulated()
                            .matchedGeometryEffect(id: transitionKey, in: transition)
                    } else {
                        BagViewEmpty()
                            .matchedGeometryEffect(id: transitionKey, in: transition)
                    }
                case .loading:
                    ProgressView()
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                case .faliedToLoad:
                    BagViewEmpty(with: .error)
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                }
            }
            #if CLIENT
            .navigationTitle("Bag")
            #elseif ADMIN
            .navigationTitle("Client Orders")
            #endif
            .onChange(of: scenePhase) { _, newValue in
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
            .alert(
                viewModel.alert?.title ?? "No Title",
                isPresented: $viewModel.showingAlert
            ) {
            } message: {
                Text(viewModel.alert?.description ?? "No description")
            }
        }
    }
    
    init(_ inMemoryOnly: Bool = false) {
        _viewModel = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    BagView(true)
}
