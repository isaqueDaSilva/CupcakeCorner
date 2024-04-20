//
//  ProfileView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State var name = ""
    var body: some View {
        NavigationStack {
            Group {
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CancelButton {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
