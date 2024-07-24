//
//  CupcakeView.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import SwiftData
import SwiftUI

struct CupcakeDetailView: View {
    @Binding var cupcake: Cupcake
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel = ViewModel()
    
    var action: (UUID) -> Void
    
    var body: some View {
        List {
            Section {
                VStack {
                    CoverImageView(coverImage: cupcake.image)
                }
                .frame(maxWidth: .infinity)
            }
            
            Section("Informations:") {
                Text(cupcake.flavor)
                
                Text(cupcake.price.currency)
            }
            
            Section("Ingredients") {
                ForEach(cupcake.ingredients, id: \.self) {
                    Text($0)
                }
            }
            
            Section {
                Button(role: .destructive) {
                    viewModel.showingConfirmation()
                } label: {
                    if viewModel.viewState == .loading {
                        ProgressView()
                    } else {
                        Text("Delete cupcake")
                    }
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
            Button("Cancel", role: .cancel) { }
            
            Button("Delete", role: .destructive) {
                viewModel.deleteCupcake(with: cupcake, and: modelContext) { cupcakeID in
                    action(cupcakeID)
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        .toolbar {
            Button("Edit") {
                viewModel.showingEditView = true
            }
        }
        .sheet(isPresented: $viewModel.showingEditView) {
            UpdateCupcakeView(cupcake: $cupcake)
        }
    }
    
    init(cupcake: Binding<Cupcake>, inMemoryOnly: Bool = false, action: @escaping (UUID) -> Void) {
        _cupcake = cupcake
        self.action = action
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    let schema = Schema([
        Cupcake.self
    ])
    
    let container = try! ModelContainer(for: schema, configurations: config)
    
    let context = ModelContext(container)
    
    context.insert(Cupcake.sampleCupcakes[0])
    print("Created Cupcake")
    
    try? context.save()
    print("Saved")
    
    let descriptor = FetchDescriptor<Cupcake>()
    let cupcakes = try! context.fetch(descriptor)
    
    return CupcakeDetailView(cupcake: .constant(cupcakes[0])) { _ in }
        .environment(\.modelContext, context)

}
