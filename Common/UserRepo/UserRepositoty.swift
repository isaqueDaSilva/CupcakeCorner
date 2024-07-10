//
//  PageController.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 21/04/24.
//

import Foundation
import SwiftData

final class UserRepositoty: ObservableObject {
    @Published var user: User?
    
    func getUser(with modelContext: ModelContext) {
        let descriptor = FetchDescriptor<User>()
        
        guard let users = try? modelContext.fetch(descriptor) else {
            self.user = nil
            return
        }
        
        guard users.count == 1 else {
            self.user = nil
            return
        }
        
        self.user = users[0]
    }
    
    deinit {
        print("UserRepository was deinitialized.")
    }
}
