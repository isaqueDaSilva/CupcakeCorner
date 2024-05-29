//
//  BuyView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct CupcakeView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel: ViewModel
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    let colums: [GridItem] = [.init(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .load:
                    CupcakeViewLoad()
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                case .loading:
                    ProgressView()
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                case .faliedToLoad:
                    EmptyStateView(
                        title: "No Cupcake Load",
                        description: "It looks like there are no cupcakes on the menu to display, please refresh the page or come back later to check out more.",
                        icon: .magnifyingglass
                    )
                    .matchedGeometryEffect(id: transitionKey, in: transition)
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
                if (newValue == .background) {
                    viewModel.task?.cancel()
                    viewModel.task = nil
                }
            }
            .refreshable {
                viewModel.loadCupcakes()
            }
            .alert(
                viewModel.error?.title ?? "No Title",
                isPresented: $viewModel.showingError
            ) {
            } message: {
                Text(viewModel.error?.description ?? "No Description")
            }
            .navigationDestination(for: Cupcake.self) { cupcake in
                #if CLIENT
                OrderView(cupcake: cupcake)
                #elseif ADMIN
                CupcakeDetailView(cupcake: cupcake)
                #endif
            }
        }
    }
    
    init(inMemoryOnly: Bool = false) {
        _viewModel = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    CupcakeView(inMemoryOnly: true)
}
