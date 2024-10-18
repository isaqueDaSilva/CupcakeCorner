//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject private var cupcakeRepo: CupcakeRepository
    @EnvironmentObject private var userRepo: UserRepository
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel
    
    @Environment(\.itsAnIPadDevice) private var itsAnIPadDevice
    
    @State private var isShowingAboutCupcake = false
    
    private let isCupcakeNew: Bool
    
    var body: some View {
        Group {
            ScrollView {
                VStack {
                    cupcakeHighlight
                        .padding(.bottom)
                    
                    containerView
                }
            }
            .padding(.horizontal)
        }
        .sheet(
            isPresented: $isShowingAboutCupcake
        ) {
            aboutTheCupcake
        }
        .alert(
            viewModel.alert.message,
            isPresented: $viewModel.isAlertDisplaying
        ) {
            if viewModel.isSuccessed {
                Button("OK") {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alert.message)
        }
        .onDisappear {
            cupcakeRepo.set(nil)
        }
    }
    
    init(
        isCupcakeNew: Bool = false,
        _ cupcakeID: UUID,
        and price: Double
    ) {
        _viewModel = .init(
            wrappedValue: .init(
                with: cupcakeID,
                and: price
            )
        )
        self.isCupcakeNew = isCupcakeNew
    }
}

extension OrderView {
    @ViewBuilder
    private var containerView: some View {
        Group {
            quantityChoice
                .disabled(viewModel.isDisable)
            
            specialRequestChoices
                .padding(.bottom)
                .disabled(viewModel.isDisable)

            orderTotalLabel
                .padding(.bottom, 10)
            
            ActionButton(
                viewState: $viewModel.viewState,
                label: "Make Order",
                width: .infinity,
                isDisabled: viewModel.isDisable
            ) {
                viewModel.makeOrder()
            }
            .font(itsAnIPadDevice ? .title2 : nil)
        }
    }
}

extension OrderView {
    @ViewBuilder
    private var cupcakeHighlight: some View {
        VStack {
            if isCupcakeNew {
                Text("New")
                    .font(itsAnIPadDevice ? .title3 : .callout)
                    .bold()
                    .foregroundStyle(.orange)
            }
            
            HStack(alignment: .center) {
                Text("\(cupcakeRepo.selectedCupcake?.flavor ?? "Unknown")'s Cupcake")
                    .headerSessionText(
                        font: itsAnIPadDevice ? .largeTitle : .title2
                    )
                    .multilineTextAlignment(.center)
                
                Button {
                    isShowingAboutCupcake = true
                } label: {
                    Icon.infoCircle.systemImage
                        .font(itsAnIPadDevice ? .title3 : nil)
                        .foregroundStyle(.blue)
                }
            }
            
            (cupcakeRepo.selectedCupcake?.image ?? Icon.questionmarkDiamond.systemImage)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 150, maxHeight: 150)
                .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

extension OrderView {
    @ViewBuilder
    private var orderTotalLabel: some View {
        LabeledContent {
            Text(viewModel.finalPrice.currency)
                .animation(.default, value: viewModel.finalPrice)
                .contentTransition(.numericText(value: Double(viewModel.finalPrice)))
        } label: {
            Text("Total:")
                .bold()
        }
        .font(itsAnIPadDevice ? .title2 : .headline)
    }
}

extension OrderView {
    @ViewBuilder
    private var quantityChoice: some View {
        VStack(alignment: .leading) {
            Text("How much cakes do you want?")
                .headerSessionText(
                    font: itsAnIPadDevice ? .largeTitle : .title2
                )
            
            HStack {
                
                Stepper(
                    "Number of Cakes: \(viewModel.quantity)",
                    value: $viewModel.quantity,
                    in: 1...20
                )
                .animation(.default, value: viewModel.quantity)
                .contentTransition(.numericText(value: Double(viewModel.quantity)))
                .font(itsAnIPadDevice ? .title2 : .headline)
            }
        }
    }
}

extension OrderView {
    @ViewBuilder
    private var specialRequestChoices: some View {
        VStack(alignment: .leading) {
            Text("Special Request")
                .headerSessionText(
                    font: itsAnIPadDevice ? .largeTitle : .title2
                )
            
            VStack {
                SpecialRequest(
                    isActive: $viewModel.extraFrosting,
                    price: viewModel.extraFrostingPrice,
                    requestName: "Extra Frosting:"
                )
                .animation(.default, value: viewModel.extraFrostingPrice)
                .contentTransition(.numericText(value: Double(viewModel.extraFrostingPrice)))
                
                SpecialRequest(
                    isActive: $viewModel.addSprinkles,
                    price: viewModel.addSprinklesPrice,
                    requestName: "Extra Sprinkles:"
                )
                .animation(.default, value: viewModel.addSprinklesPrice)
                .contentTransition(.numericText(value: Double(viewModel.addSprinklesPrice)))
            }
            .font(itsAnIPadDevice ? .title2 : .headline)
        }
    }
}

extension OrderView {
    @ViewBuilder
    private func SpecialRequest(
        isActive: Binding<Bool>,
        price: Double,
        requestName: String
    ) -> some View {
        Button {
            withAnimation(.spring) {
                isActive.wrappedValue.toggle()
            }
        } label: {
            HStack {
                LabeledContent(
                    requestName,
                    value: "\(isActive.wrappedValue ? "-" : "+") \(price.currency)"
                )
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background() {
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2.0)
                    .fill(isActive.wrappedValue ? .blue : Color(uiColor: .systemGray3))
            }
        }
        .buttonStyle(.plain)
    }
}

extension OrderView {
    private var madeWithText: AttributedString {
        var message = AttributedString("Made with: ")
        message.font = itsAnIPadDevice ? .title2 : .headline
        _ = message.font?.weight(.bold)
        
        return message
    }
    
    private var ingredientsText: AttributedString {
        let cupcakeIngredients = cupcakeRepo.selectedCupcake?.ingredients ?? []
        var ingredients = AttributedString(cupcakeIngredients.joined(separator: ", "))
        ingredients.font = itsAnIPadDevice ? .title2 : .headline
        _ = ingredients.font?.weight(.medium)
        ingredients.foregroundColor = .secondary
        
        return ingredients
    }
    
    private var createAtText: AttributedString {
        var message = AttributedString("Create At: ")
        message.font = itsAnIPadDevice ? .title2 : .headline
        _ = message.font?.weight(.bold)
        
        return message
    }
    
    private var dateDescriptionText: AttributedString {
        let cupcakeCreateAt = cupcakeRepo.selectedCupcake?.createAt ?? .now
        var dateDescription = AttributedString(cupcakeCreateAt.dateString(isDisplayingTime: false))
        dateDescription.font = itsAnIPadDevice ? .title2 : .headline
        _ = dateDescription.font?.weight(.medium)
        dateDescription.foregroundColor = .secondary
        
        return dateDescription
    }
    
    @ViewBuilder
    private var aboutTheCupcake: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    (cupcakeRepo.selectedCupcake?.image ?? Icon.questionmarkDiamond.systemImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 150, maxHeight: 150)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    HStack(alignment: .center) {
                        Icon.infoCircle.systemImage
                            .font(itsAnIPadDevice ? .title : .title2)
                            .bold()
                            .foregroundStyle(.blue)
                        Text("About the Cupcake")
                            .headerSessionText(font: itsAnIPadDevice ? .title : .title2)
                    }
                    .padding(.bottom, 5)
                    
                    Text(madeWithText + ingredientsText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LabeledContent {
                        Text(dateDescriptionText)
                    } label: {
                        Text(createAtText)
                    }

                }
                .padding()
            }
            .navigationTitle(cupcakeRepo.selectedCupcake?.flavor ?? "Unknown Flavor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    ActionButton(viewState: .constant(.load), label: "OK") {
                        isShowingAboutCupcake = false
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    @Previewable @Environment(\.verticalSizeClass) var vSizeClass
    
    @Previewable @Environment(\.horizontalSizeClass) var hSizeClass
    
    var itsAnIPadDevice: Bool {
        vSizeClass == .regular && hSizeClass == .regular
    }
    
    let managerPreview = StorageManager.preview()
    
    NavigationStack {
        OrderView(
            .init(),
            and: .random(in: 1...100)
        )
        .environmentObject(UserRepository(storageManager: managerPreview))
        .environmentObject(CupcakeRepository(storageManager: managerPreview))
        .environment(\.itsAnIPadDevice, itsAnIPadDevice)
    }
}

#Preview {
    @Previewable @Environment(\.verticalSizeClass) var vSizeClass
    
    @Previewable @Environment(\.horizontalSizeClass) var hSizeClass
    
    var itsAnIPadDevice: Bool {
        vSizeClass == .regular && hSizeClass == .regular
    }
    
    let managerPreview = StorageManager.preview()
    
    NavigationStack {
        OrderView(
            isCupcakeNew: true,
            .init(),
            and: .random(in: 1...100)
        )
        .environmentObject(UserRepository(storageManager: managerPreview))
        .environmentObject(CupcakeRepository(storageManager: managerPreview))
        .environment(\.itsAnIPadDevice, itsAnIPadDevice)
    }
}
#endif
