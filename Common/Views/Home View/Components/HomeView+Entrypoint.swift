//
//  HomeView+Entrypoint.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/07/24.
//

import SwiftUI

extension HomeView {
    @ViewBuilder
    func Home() -> some View {
        Group {
            TabBarHomeView()
        }
        .environmentObject(userRepo)
        .onAppear {
            if userRepo.user == nil {
                userRepo.getUser(with: modelContext)
            }
        }
    }
}
