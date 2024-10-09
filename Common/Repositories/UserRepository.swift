//
//  UserRepository.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/21/24.
//

import Foundation
import SwiftData

@MainActor
final class UserRepository: ObservableObject {
    @Published var user: User?
    
    private let storageManager: StorageManager
    
    func insert(
        _ user: User.Get
    ) async throws {
        let newUser = try await storageManager.insert(new: user, as: User.self)
        
        await MainActor.run {
            self.user = newUser
        }
    }
    
    func load(isFirstOpen: Bool = false) async throws {
        let users = try await storageManager.find(User.self)
        
        if !isFirstOpen {
            guard !users.isEmpty && users.count == 1 else {
                throw RepositoryError.invalidQuantity
            }
        }
        
        await MainActor.run {
            user = users.isEmpty ? nil : users[0]
        }
    }
    
    func update(with userResult: User.Get) async throws {
        guard let user else { throw RepositoryError.noItem }
        
        
        let userUpdated = user.update(from: userResult)
        
        await MainActor.run {
            self.user = userUpdated
        }
    }
    
    func delete() async throws {
        guard let user else { throw RepositoryError.noItem }
        
        try await storageManager.remove(user)
        
        await MainActor.run {
            self.user = nil
        }
    }
    
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    deinit {
        print("UserRepository was deinitialized.")
    }
}
