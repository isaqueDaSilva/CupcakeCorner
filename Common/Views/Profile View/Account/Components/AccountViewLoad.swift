//
//  AccountViewLoad.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import SwiftUI


extension AccountView {
    @ViewBuilder
    func AccountViewLoad() -> some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.title3)
                        .bold()
                    
                    Text(viewModel.email)
                        .font(.subheadline)
                }
            }
            
            Section {
                #if CLIENT
                LabeledContent("Main Shipping:") {
                    Text(viewModel.mainShipping)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Main Payment:") {
                    Text(viewModel.mainPayment)
                        .multilineTextAlignment(.trailing)
                }
                
                #elseif ADMIN
                NavigationLink {
                    CreateAnAccount()
                } label: {
                    Text("Create New User Admin")
                }

                #endif
            }
            
            Section {
                Button(role: .destructive) {
                    viewModel.logout {
                        pageController.setNewValue(false)
                    }
                } label: {
                    switch viewModel.signOutViewState {
                    case .load, .faliedToLoad:
                        Text("Sign Out")
                    case .loading:
                        ProgressView()
                    }
                }
                .disabled(viewModel.signOutViewState == .loading)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AccountView(inMemoryOnly: true).AccountViewLoad()
            .environmentObject(PageController())
    }
}
