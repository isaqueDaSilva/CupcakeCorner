//
//  OrderFilterPickerView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 10/4/24.
//

import SwiftUI

struct OrderFilterPickerView: View {
    @Binding var filter: Status
    var filerList: [Status]
    
    var body: some View {
        Picker("Orders", selection: $filter) {
            ForEach(filerList, id: \.id) { status in
                Text(status.displayedName)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}

#Preview {
    OrderFilterPickerView(filter: .constant(.ordered), filerList: Status.allStatusCase)
}
