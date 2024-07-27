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
            _ cupcakesGetted: [Cupcake.Get],
            with context: ModelContext
        ) throws {
            for cupcake in cupcakesGetted {
                let predicate = #Predicate<Cupcake> { savedCupcake in
                    savedCupcake.id == cupcake.id
                }
                
                let descriptor = FetchDescriptor<Cupcake>(predicate: predicate)
                let cupcakes = try context.fetch(descriptor)
                
                guard (!cupcakes.isEmpty) && (cupcakes.count == 1) && (cupcakes[0].isEqual(to: cupcake)) else {
                    if cupcakes.isEmpty {
                        let newCupcake = Cupcake(from: cupcake)
                        context.insert(newCupcake)
                    } else if cupcakes.count == 1 && !cupcakes[0].isEqual(to: cupcake) {
                        cupcakes[0].update(from: cupcake)
                    } else if cupcakes.count > 1 {
                        for cupcake in cupcakes {
                            context.delete(cupcake)
                        }
                        let newCupcake = Cupcake(from: cupcake)
                        context.insert(newCupcake)
                    }
                    continue
                }
            }
            
            guard context.hasChanges else { return }
            
            try context.save()
        }
    }
}
