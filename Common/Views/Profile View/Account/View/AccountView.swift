//
//  Profile.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/04/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var pageController: PageController
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .load:
                    AccountViewLoad()
                case .loading:
                    ProgressView()
                case .faliedToLoad:
                    AccountViewFaliedToLoad()
                }
            }
            .navigationTitle("Account")
            .alert(
                viewModel.error?.title ?? "No Title",
                isPresented: $viewModel.showingError
            ) {
            } message: {
                Text(viewModel.error?.description ?? "No description.")
            }
        }
    }
    
    init(inMemoryOnly: Bool = false) {
        _viewModel = StateObject(wrappedValue: ViewModel(inMemoryOnly: inMemoryOnly))
    }
}

#Preview {
    NavigationStack {
        AccountView(inMemoryOnly: true).AccountViewLoad()
            .environmentObject(PageController())
    }
}
