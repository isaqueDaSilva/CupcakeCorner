//
//  OrderView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 04/04/24.
//

import SwiftUI

struct OrderView: View {
    @State private var numbersOfCakes = 1
    @State private var specialRequests = false
    @State private var extraFrosting = false
    @State private var extraSprinkles = false
    
    let colums: [GridItem] = [.init(.adaptive(minimum: 150))]
    
    var body: some View {
        List {
            Section {
                ProductHighlight(
                    flavor: "Chocolate",
                    image: Icon.house.systemImage
                )
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color(uiColor: .systemGray6))
            
            Section {
                Text("How much cakes do you want?")
                    .headerSessionText()
                
                Stepper("Number of Cakes: \(numbersOfCakes)", value: $numbersOfCakes, in: 1...20)
            }
            .listRowSeparator(.hidden, edges: .top)
            
            Section {
                Text("Special Request")
                    .headerSessionText()
                
                SpecialRequestButton(
                    isActive: $extraFrosting,
                    requestName: "Extra Frosting"
                )
                
                SpecialRequestButton(
                    isActive: $extraSprinkles,
                    requestName: "Extra Sprinkles"
                )
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        
                    } label: {
                        Icon.bookmark.systemImage
                    }
                    .padding(.trailing)
                    
                    //ActionButton(label: "Next") { }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                InformationLabel(15)
            }
        }
        .toolbarBackground(.visible, for: .automatic)
    }
}

#Preview {
    NavigationStack {
        OrderView()
    }
}
