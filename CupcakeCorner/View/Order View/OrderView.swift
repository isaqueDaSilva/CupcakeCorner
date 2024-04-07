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
                    
                    ActionButton(label: "Next") { }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                VStack {
                    SubtotalLabel(15)
                    
                }
                .padding(.bottom)
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


extension OrderView {
    struct ProductHighlight: View {
        let flavor: String
        let image: Image
        
        var body: some View {
            VStack {
                Text("Buy the \(flavor) Cupcake")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 150, maxHeight: 150)
                    .padding()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

extension OrderView {
    struct SpecialRequestButton: View {
        @Binding var isActive: Bool
        let requestName: String
        
        var body: some View {
            Button {
                withAnimation(.spring) {
                    isActive.toggle()
                }
            } label: {
                GroupBox {
                    LabeledContent(requestName, value: "\(isActive ? "-" : "+") \(Double(5).currency)")
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .fill(isActive ? .blue : Color(uiColor: .systemGray6))
                }
            }
        }
    }
}
