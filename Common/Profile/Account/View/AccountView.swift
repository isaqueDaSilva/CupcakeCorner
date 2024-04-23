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
    
    @State private var viewModel = ViewModel()
    @State private var navigation = Navigation()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            Group {
                switch viewModel.viewState {
                case .load:
                    AccountViewLoad()
                case .loading, .faliedToLoad:
                    ProgressView()
                }
            }
            .navigationTitle("Account")
            #if CLIENT
            .toolbar {
                ActionButton(
                    viewState: $viewModel.buttonViewState,
                    label: "OK"
                ) {
                    dismiss()
                }
            }
            #endif
            .alert(
                viewModel.error?.title ?? "No Title",
                isPresented: $viewModel.showingError
            ) {
            } message: {
                Text(viewModel.error?.description ?? "No description.")
            }
        }
    }
}

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
                NavigationLink(value: "abc") {
                    Text("Orders")
                }
                
                #if CLIENT
                NavigationLink(value: "abc") {
                    Text("Favorites Cupcakes")
                }
                #endif
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
                NavigationLink(value: "abc") {
                    Text("Cupcakes")
                }
                
                NavigationLink(value: "abc") {
                    Text("Create New Admin User")
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
        AccountView().AccountViewLoad()
            .environmentObject(PageController())
    }
}
