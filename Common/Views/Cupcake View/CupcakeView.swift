//
//  CupcakeView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/27/24.
//

import SwiftUI

struct CupcakeView: View {
    @EnvironmentObject private var userRepo: UserRepository
    @EnvironmentObject private var cupcakeRepo: CupcakeRepository
    
    @State private var viewDisplayedCount: Int = 0
    @State private var presentedCupcakes: [Cupcake] = []
    
    #if ADMIN
    @State private var showCreateNewCupcake = false
    #endif
    
    @StateObject private var viewModel: ViewModel
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    private let colums: [GridItem] = [.init(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack(path: $presentedCupcakes) {
            ScrollView {
                Group {
                    switch viewModel.viewState {
                    case .load, .faliedToLoad:
                        switch cupcakeRepo.cupcakes.isEmpty {
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
                            cupcakeViewLoad
                                .matchedGeometryEffect(
                                    id: transitionKey,
                                    in: transition
                                )
                        }
                    case .loading:
                        ProgressView()
                            .containerRelativeFrame(.vertical)
                            .matchedGeometryEffect(
                                id: transitionKey,
                                in: transition
                            )
                    }
                    
                }
            }
            .onAppear {
                viewDisplayedCount += 1
                
                if viewDisplayedCount == 1 && cupcakeRepo.cupcakes.isEmpty {
                    viewModel.fetchCupcakes(with: cupcakeRepo.cupcakes.isEmpty) { cupcakesResult in
                        try await cupcakeRepo.load(with: cupcakesResult)
                    }
                }
            }
            .navigationDestination(for: Cupcake.self) { cupcake in
                cupcakeRepo.set(cupcake)
                
                #if CLIENT
                return OrderView(
                    cupcake.id,
                    and: cupcake.price
                )
                #elseif ADMIN
                return CupcakeDetailView()
                #endif
            }
            .alert(
                viewModel.alert.title,
                isPresented: $viewModel.showingAlert
            ) {
            } message: {
                Text(viewModel.alert.message)
            }
            .refreshable {
                viewModel.fetchCupcakes(with: cupcakeRepo.cupcakes.isEmpty) { cupcakesResult in
                    try await cupcakeRepo.load(with: cupcakesResult)
                }
            }
            #if ADMIN
            .toolbar {
                Button {
                    showCreateNewCupcake = true
                } label: {
                    Icon.plusCircle.systemImage
                }
                #if !DEBUG
                .disabled(userRepo.user == nil)
                #endif
            }
            .sheet(isPresented: $showCreateNewCupcake) {
                CreateCupcakeView()
                    .environmentObject(cupcakeRepo)
            }
            #endif
            .environmentObject(cupcakeRepo)
            .environmentObject(userRepo)
        }
    }
    
    init(inMemoryOnly: Bool = false) {
        _viewModel = .init(wrappedValue: .init(inMemoryOnly: inMemoryOnly))
    }
}

extension CupcakeView {
    @ViewBuilder
    private var cupcakeViewLoad: some View {
        LazyVStack(alignment: .leading) {
            #if CLIENT
            headerMessage
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            newestCupcakeHighlights
                .frame(maxHeight: 500)
                .frame(maxWidth: .infinity)
            
            Text("Cupcakes")
                .headerSessionText()
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            #endif
            
            cupcakeScrollList
        }
        .padding(.horizontal)
        .padding([.top, .bottom], 5)
        #if CLIENT
        .navigationTitle("Buy")
        #elseif ADMIN
        .navigationTitle("Cupcakes")
        #endif
    }
}

extension CupcakeView {
    @ViewBuilder
    private func buyButton(_ cupcake: Cupcake) -> some View {
        HStack {
            #if os(iOS)
            Text("From \(cupcake.price.currency)")
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            #endif
            NavigationLink(value: cupcake) {
                Text("Buy")
                    #if canImport(AppKit)
                    .foregroundStyle(Color(nsColor: .blue))
                    #elseif canImport(UIKit)
                    .foregroundStyle(.blue)
                    #endif
                    .padding([.top, .bottom], 2)
                    .padding(.horizontal, 10)
                    .background(
                        Capsule()
                        #if canImport(AppKit)
                            .fill(.gray)
                        #elseif canImport(UIKit)
                            .fill(.gray.opacity(0.25))
                        #endif
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

extension CupcakeView {
    @ViewBuilder
    private var headerMessage: some View {
        HStack(alignment: .top) {
            Icon.shippingBox.systemImage
                .font(.largeTitle)
            
            VStack(alignment: .leading) {
                Text("Make your order")
                    .font(.title3)
                    .bold()
                
                Text("And receive a free gift when you pick up your order.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#if CLIENT
extension CupcakeView {
    @ViewBuilder
    private var newestCupcakeHighlights: some View {
        VStack {
            if let newstCupcake = cupcakeRepo.newestCupcake {
                Group {
                    #if os(iOS)
                    cupcakeHighlight_iOS(newstCupcake)
                    #elseif os(macOS)
                    cupcakeHighlight_macOS(newstCupcake)
                    #endif
                }
                .overlay {
                    buyButton(newstCupcake)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.horizontal, 10)
                        #if os(macOS)
                        .padding(.bottom)
                        #elseif os(iOS)
                        .padding(.bottom, 22.5)
                        #endif
                }
            }
        }
        .padding(.bottom)
    }
}
#endif

#if os(iOS) && CLIENT
extension CupcakeView {
    @ViewBuilder
    private func cupcakeHighlight_iOS(_ newestCupcake: Cupcake) -> some View {
        VStack {
            Text("New")
                .headerSessionText()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GroupBox {
                Image(by: newestCupcake.coverImage)
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom)
                    .frame(alignment: .leading)
                
            } label: {
                Text(newestCupcake.flavor)
                
                Text("Made with \(newestCupcake.ingredients.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
#endif

#if os(macOS) && CLIENT
extension CupcakeView {
    @ViewBuilder
    private func cupcakeHighlight_macOS(_ newestCupcake: Cupcake) -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("New")
                            .headerSessionText()
                        
                        Text(newestCupcake.flavor)
                        
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                    newestCupcake.image
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom)
                        .frame(maxWidth: 150)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Text("Made with \(newestCupcake.ingredients.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 50)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(nsColor: .systemGray))
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
#endif

extension CupcakeView {
    @ViewBuilder
    private func CupcakeCard(
        with flavor: String,
        and cover: Image
    ) -> some View {
        #if os(iOS)
        GroupBox(flavor) {
            cover
                .resizable()
                .scaledToFit()
        }
        #elseif os(macOS)
        HStack {
            VStack {
                Text(flavor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                cover
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(nsColor: .systemGray))
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        #endif
    }
}

extension CupcakeView {
    @ViewBuilder
    private var cupcakeScrollList: some View {
        LazyVGrid(columns: colums) {
            ForEach(
                cupcakeRepo.cupcakes.valuesArray.sorted(
                    by: { $0.createAt > $1.createAt }
                ),
                id: \.id
            ) { cupcake in
                NavigationLink(value: cupcake) {
                    CupcakeCard(
                        with: cupcake.flavor,
                        and: cupcake.image
                    )
                }
                .buttonStyle(.plain)
                #if os(iOS)
                .buttonStyle(.plain)
                #endif
            }
        }
    }
}

extension CupcakeView {
    var emptyStateDescription: String {
        #if CLIENT
        return "It looks like there are no cupcakes on the menu to display, please refresh the page or come back later to check out more."
        #elseif ADMIN
        return "There are no cupcakes to be displayed. This may be because you are not logged in to your account or there are no cupcakes created."
        #endif
    }
}

#Preview {
    let managerPreview = StorageManager.preview()
    
    CupcakeView()
        .environmentObject(CupcakeRepository(storageManager: managerPreview))
        .environmentObject(UserRepository(storageManager: managerPreview))
}
