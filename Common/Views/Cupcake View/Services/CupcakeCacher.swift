//
//  CupcakeCacher.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 13/06/24.
//

import Foundation
import SwiftData

extension CupcakeView {
    enum CupcakeCacher {
        static func caching(
            _ cupcakes: [Cupcake.Get],
            with context: ModelContext
        ) throws {
            for cupcake in cupcakes {
                let predicate = #Predicate<Cupcake> { savedCupcake in
                    savedCupcake.id == cupcake.id
                }
                
                let descriptor = FetchDescriptor<Cupcake>(predicate: predicate)
                let cupcakes = try context.fetch(descriptor)
                
                if !cupcakes.isEmpty {
                    for cupcake in cupcakes {
                        context.delete(cupcake)
                    }
                }
                
                let newCupcake = Cupcake(from: cupcake)
                context.insert(newCupcake)
            }
            
            try context.save()
        }
    }
}
