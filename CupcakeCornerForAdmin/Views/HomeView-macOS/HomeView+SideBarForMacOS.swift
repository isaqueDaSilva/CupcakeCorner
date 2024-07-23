//
//  HomeView+SideBarForMacOS.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 20/07/24.
//

import SwiftUI

#if ADMIN && os(macOS)
extension HomeView {
    @ViewBuilder
    func SideBarHomeView() -> some View {
        ScrollView {
            ForEach(TabSection.allCases(with: nil)) { section in
                Label {
                    section.title
                        .foregroundStyle(.white)
                } icon: {
                    section.icon
                        .foregroundStyle(selection.id == section.id ? .white : .accentColor)
                }
                .tag(section)
                .sectionSelector(with: section.id, and: selection.id)
                .onTapGesture {
                    selection = section
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .safeAreaInset(edge: .bottom) {
            let profileSection = TabSection.profile(userRepo.user?.name)
            
            Label {
                profileSection.title
            } icon: {
                profileSection.icon
                    .foregroundStyle(selection.id == profileSection.id ? .white : .accentColor)
            }
            .tag(profileSection)
            .buttonStyle(BorderlessButtonStyle())
            .sectionSelector(with: profileSection.id, and: selection.id)
            .padding()
            .onTapGesture {
                selection = profileSection
            }
        }
    }
}
#endif

#Preview {
    HomeView().SideBarHomeView()
}
