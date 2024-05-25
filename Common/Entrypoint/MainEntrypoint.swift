//
//  MainEntrypoint.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 07/05/24.
//

import SwiftUI

/// The main scene's entry point for the app.
struct MainEntrypoint: Scene {
    private let cacheStore = CacheStoreService()
    
    var body: some Scene {
        WindowGroup {
            HomeView(cacheStore)
        }
    }
}
