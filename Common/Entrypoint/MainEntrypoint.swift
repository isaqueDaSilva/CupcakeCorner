//
//  MainEntrypoint.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 07/05/24.
//

import SwiftUI

struct MainEntrypoint: Scene {
    @StateObject private var cacheStorage = CacheStorageService()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(cacheStorage)
        }
    }
}
