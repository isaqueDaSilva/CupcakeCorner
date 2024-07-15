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
                NavigationLink {
                    if let user = userRepo.user {
                        UpdateAccountView(user: user)
                            .environmentObject(userRepo)
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(userRepo.user?.name ?? "No User Saved")
                            .font(.title3)
                            .bold()
                        
                        Text(userRepo.user?.email ?? "No User Saved")
                            .font(.subheadline)
                    }
                }
            }
            
            Section {
                #if CLIENT
                LabeledContent("Main Payment:") {
                    Text(userRepo.user?.paymentMethod.displayedName ?? "No User Saved")
                        .multilineTextAlignment(.trailing)
                }
                
                #elseif ADMIN
                NavigationLink {
                    CreateAnAccountView()
                } label: {
                    Text("Create New User Admin")
                }

                #endif
            }
            
            Section {
                Button(role: .destructive) {
                    if let user = userRepo.user {
                        viewModel.logout(with: user, and: modelContext) {
                            userRepo.getUser(with: modelContext)
                        }
                    } else {
                        viewModel.displayError()
                    }
                } label: {
                    switch viewModel.signOutViewState {
                    case .load, .faliedToLoad:
                        HStack {
                            Icon.rectangleAndArrow.systemImage
                            Text("Sign Out")
                        }
                    case .loading:
                        ProgressView()
                    }
                }
                .disabled(viewModel.signOutViewState == .loading || viewModel.deleteAccountViewState == .loading)
            }
            
            Section {
                Button(role: .destructive) {
                    viewModel.showingDeleteAccountAlert()
                } label: {
                    switch viewModel.signOutViewState {
                    case .load, .faliedToLoad:
                        HStack {
                            Icon.trash.systemImage
                            Text("Delete Account")
                        }
                    case .loading:
                        ProgressView()
                    }
                }
                .disabled(viewModel.signOutViewState == .loading || viewModel.deleteAccountViewState == .loading)
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        ProfileView(inMemoryOnly: true)
//    }
//}
