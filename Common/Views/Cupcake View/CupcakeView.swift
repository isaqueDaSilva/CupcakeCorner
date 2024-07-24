//
//  BuyView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftData
import SwiftUI

struct CupcakeView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var userRepo: UserRepositoty
    @StateObject var viewModel: ViewModel
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    let colums: [GridItem] = [.init(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .load, .faliedToLoad:
                    if viewModel.cupcakes.isEmpty {
                        EmptyStateView(
                            title: "No Cupcake Load",
                            description: emptyStateDescription,
                            icon: .magnifyingglass
                        )
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                    } else {
                        CupcakeViewLoad()
                            .matchedGeometryEffect(id: transitionKey, in: transition)
                    }
                case .loading:
                    ProgressView()
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                }
            }
            .onAppear {
                if viewModel.cupcakes.isEmpty {
                    #if CLIENT
                    viewModel.loadCupcakes(with: modelContext)

                    #elseif ADMIN
                    if !viewModel.inMemoryOnly {
                        guard (userRepo.user != nil) && !viewModel.inMemoryOnly else {
                            viewModel.viewState = .load
                            return
                        }
                        
                        viewModel.loadCupcakes(with: modelContext)
                    } else {
                        viewModel.loadCupcakes(with: modelContext)
                    }
                    #endif
                }
            }
            .alert(
                viewModel.errorTitle,
                isPresented: $viewModel.showingError
            ) {
            } message: {
                Text(viewModel.errorDescription)
            }
            .toolbar {
                if viewModel.cupcakes.isEmpty {
                    Button {
                        #if ADMIN
                        if userRepo.user != nil {
                            viewModel.loadCupcakes(with: modelContext)
                        } else {
                            viewModel.displayError(title: "You are not connected")
                        }
                        #elseif CLIENT
                        viewModel.loadCupcakes(with: modelContext)
                        #endif
                    } label: {
                        Icon.arrowClockwise.systemImage
                    }
                    .disabled(viewModel.viewState == .loading)
                }
                
                #if ADMIN
                if userRepo.user != nil {
                    Button {
                        viewModel.showingCreateNewCupcakeView = true
                    } label: {
                        Icon.plusCircle.systemImage
                    }
                }
                #endif
            }
            #if ADMIN
            .sheet(isPresented: $viewModel.showingCreateNewCupcakeView) {
                CreateCupcakeView { cupcake in
                    viewModel.insertNewCupcake(with: cupcake)
                }
            }
            #endif
        }
    }
    
    init(inMemoryOnly: Bool = false) {
        _viewModel = StateObject(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try? ModelContainer(for: Cupcake.self, User.self, configurations: config)
    
    guard let container else { return CupcakeView(inMemoryOnly: true) }
    
    let context = ModelContext(container)
    
    for cupcake in Cupcake.sampleCupcakes {
        context.insert(cupcake)
    }
    
    print("Cupcakes Saved")
    
    context.insert(User.sampleUser)
    
    try? context.save()
    print("User Saved")
    
    return CupcakeView(inMemoryOnly: true)
        .environment(\.modelContext, context)
        .environmentObject(UserRepositoty())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}
