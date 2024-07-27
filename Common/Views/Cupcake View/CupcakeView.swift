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
            ScrollView {
                Group {
                    switch viewModel.viewState {
                    case .load, .faliedToLoad:
                        switch viewModel.cupcakes.isEmpty {
                        case true:
                            EmptyStateView(
                                title: "No Cupcake Load",
                                description: emptyStateDescription,
                                icon: .magnifyingglass
                            )
                            .containerRelativeFrame(.vertical)
                            .matchedGeometryEffect(
                                id: transitionKey,
                                in: transition
                            )
                        case false:
                            CupcakeViewLoad()
                                .matchedGeometryEffect(
                                    id: transitionKey,
                                    in: transition
                                )
                        }
                    case .loading:
                        ProgressView()
                            .containerRelativeFrame(.vertical)
                            .matchedGeometryEffect(id: transitionKey, in: transition)
                    }
                }
            }
            .onAppear {
                if viewModel.cupcakes.isEmpty {
                    viewModel.loadCupcakes(
                        with: userRepo.user != nil,
                        and: modelContext
                    )
                }
            }
            .alert(
                viewModel.errorTitle,
                isPresented: $viewModel.showingError
            ) {
            } message: {
                Text(viewModel.errorDescription)
            }
            .refreshable {
                viewModel.loadCupcakes(
                    with: userRepo.user != nil,
                    and: modelContext
                )
            }
            #if ADMIN
            .toolbar {
                if userRepo.user != nil {
                    Button {
                        viewModel.openCreateNewCupcakeView()
                    } label: {
                        Icon.plusCircle.systemImage
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingCreateNewCupcakeView) {
                CreateCupcakeView { cupcake in
                    viewModel.insertNewCupcake(with: cupcake)
                }
            }
            .onChange(of: userRepo.user) { _, _ in
                viewModel.deleteAllCupcakes(with: modelContext)
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
    
    let userRepo = UserRepositoty()
    userRepo.getUser(with: context)
    
    return CupcakeView(inMemoryOnly: true)
        .environment(\.modelContext, context)
        .environmentObject(userRepo)
}
