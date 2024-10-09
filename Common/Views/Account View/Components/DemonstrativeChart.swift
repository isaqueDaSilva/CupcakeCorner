//
//  DemonstrativeChart.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/5/24.
//


import Charts
import SwiftUI

struct DemonstrativeChart: View {
    @EnvironmentObject private var cupcakeRepo: CupcakeRepository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .bold()
            
            Text("Total: \(total)")
                .headerSessionText(
                    font: .footnote,
                    color: .secondary
                )
            
            Chart {
                RuleMark(y: .value("Average", avarge))
                    .foregroundStyle(.mint)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                
                ForEach(cupcakeRepo.cupcakes.valuesArray, id: \.id) { cupcake in
                    BarMark(
                        x: .value(
                            "Cupcakes",
                            cupcake.flavor
                        ),
                        y: .value(
                            "Sale numbers",
                            cupcake.orders?.reduce(0, { $0 + $1.quantity}) ?? 0
                        )
                    )
                    .foregroundStyle(Color.pink.gradient)
                    .cornerRadius(5)
                }
            }
            .frame(height: 200)
            
            HStack {
                Image(systemName: "line.diagonal")
                    .rotationEffect(Angle(degrees: 45))
                    .foregroundColor(.mint)
                
                Text("Avarge")
                    .headerSessionText(
                        font: .caption2,
                        color: .secondary
                    )
            }
        }
    }
}

extension DemonstrativeChart {
    private var total: Int {
        var ordersNumber = 0
        print(cupcakeRepo.cupcakes.count)
        for cupcake in cupcakeRepo.cupcakes.valuesArray {
            for order in (cupcake.orders ?? []) {
                ordersNumber += order.quantity
            }
        }
        
        return ordersNumber
    }
    
    private var avarge: Int {
        guard cupcakeRepo.cupcakes.count > 0 else { return 0 }
        return total / cupcakeRepo.cupcakes.count
    }
    
    private var text: String {
        #if ADMIN
        return "Cupcake Sales"
        #elseif CLIENT
        return "Total Purchases"
        #endif
    }
}

import SwiftData
#Preview {
    let manager = StorageManager.preview()
    
    DemonstrativeChart()
        .environmentObject(CupcakeRepository(storageManager: manager))
}
