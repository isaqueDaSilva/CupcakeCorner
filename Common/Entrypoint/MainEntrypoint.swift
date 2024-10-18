//
//  MainEntrypoint.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import SwiftData
import SwiftUI

/// The Main scene of the App.
struct MainEntrypoint: Scene {
    /// The default model container of the App.
    private let container: ModelContainer
    
    /// The main storage manager of the app.
    private let storageManager: StorageManager
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    /// Sets if the current device used is an iPad base on vertical and horizontal size class.
    private var itsAnIPadDevice: Bool {
        vSizeClass == .regular && hSizeClass == .regular
    }
    
    /// Set if the current screen that has been displeyed is the Splash Screen.
    @State private var isSplashViewPresented = true
    
    /// Set if a Storage error that will be needed to display to user.
    @State private var showError = false
    
    /// Set the main ``UserRepository`` instance that will be used inside the app.
    @StateObject var userRepo: UserRepository
    
    /// Set the main ``CupcakeRepository`` instance that will be used inside the app.
    @StateObject var cupcakeRepo: CupcakeRepository
    
    /// Set the main ``OrderRepository`` instance that will be used inside the app.
    @StateObject var orderRepo: OrderRepository
    
    /// Set a NamespaceID to use as identifier on views marked with `.matchedGeometryEffect(id:in:)` modifier saying to compiler that those views are the same.
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
            .task(priority: .high) {
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
    /// Identifies whether the current device is an iPad.
    @Entry var itsAnIPadDevice = false
}
