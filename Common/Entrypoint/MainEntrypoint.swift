//
//  MainEntrypoint.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import SwiftData
import SwiftUI

struct MainEntrypoint: Scene {
    private let container: ModelContainer
    private let storageManager: StorageManager
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    private var itsAnIPadDevice: Bool {
        #if os(iOS)
        vSizeClass == .regular && hSizeClass == .regular
        #elseif os(macOS)
        false
        #endif
    }
    
    private var isMacOS: Bool {
        #if os(macOS)
        true
        #else
        false
        #endif
    }
    
    @State private var isSplashViewPresented = true
    @State private var showError = false
    
    @StateObject var userRepo: UserRepository
    @StateObject var cupcakeRepo: CupcakeRepository
    @StateObject var orderRepo: OrderRepository
    
    @Namespace private var transition
    private var transitionKey = NamespaceKey.transition.rawValue
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch isSplashViewPresented {
                case true:
                    SplashScreen(isSplashViewShowing: $isSplashViewPresented)
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                case false:
                    HomeView()
                        .matchedGeometryEffect(id: transitionKey, in: transition)
                }
            }
            .environmentObject(userRepo)
            .environmentObject(cupcakeRepo)
            .environmentObject(orderRepo)
            .environment(\.itsAnIPadDevice, itsAnIPadDevice)
            .environment(\.isMacOS, isMacOS)
            .task {
                do {
                    try await userRepo.load()
                } catch {
                    await MainActor.run {
                        self.showError = true
                    }
                }
            }
            .alert("Failed to load user data.", isPresented: $showError) {
            } message: {
                Text("Some unexpected error occurred. Please try relounching the app or try again later.")
            }
        }
    }
    
    init() {
        do {
            let container = try ModelContainer(for: User.self, Cupcake.self, Order.self)
            self.container = container
            let storageManager = StorageManager(with: container)
            self.storageManager = storageManager
            _userRepo = StateObject(wrappedValue: .init(storageManager: storageManager))
            _cupcakeRepo = StateObject(wrappedValue: .init(storageManager: storageManager))
            _orderRepo = StateObject(wrappedValue: .init(storageManager: storageManager))
        } catch {
            fatalError("Failed to create ModelContainer for Persistences Models: \(error)")
        }
    }
}

extension EnvironmentValues {
    @Entry var itsAnIPadDevice = false
    @Entry var isMacOS = false
}
