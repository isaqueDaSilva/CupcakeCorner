//
//  KeychainService.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation
import Security

/// An object for manage the operation of the Keychain.
struct KeychainService {
    /// Stores the key for identifier a new Token in the Keychain.
    private static let key = Keys.userToken.rawValue
    
    /// Stores a new token in the Keychain
    /// - Parameter token: An instance value of the token.
    static func store(for token: Token) throws -> OSStatus {
        // Checks if has some item saved.
        // If it has, will be executing a
        // delete action for clean the store.
        if (try? !retrive().isEmpty) != nil {
            _ = try delete()
        }
        
        // Encoding the token value.
        let encoder = JSONEncoder()
        let tokenData = try encoder.encode(token)
        
        // Creating a query dictionary
        // for saving in the Keychain.
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: tokenData
        ]
        
        // Peforms the save action
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Checks the staus is equal to success.
        // If no equal, the save error is throwing.
        guard status == errSecSuccess else {
            throw KeychainError.saveError
        }
        
        return status
    }
    
    /// Unwrapping the token value saved in the keychain.
    /// - Returns: Returns the String value of the Token.
    static func retrive() throws -> String {
        // Creating a query dictionary
        // with some information about
        // how the search will be performed.
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        // A property that stores a dictionary
        // when the search is finished with success.
        var item: CFTypeRef?
        
        // Perform a search action.
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        // Checking if some item is found.
        guard status != errSecItemNotFound else {
            throw KeychainError.noToken
        }
        
        // Checking if the status is equal to success.
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        // Checking if has some item in the item variable
        // and unwrapping the value in the "kSecValueData" key.
        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data else {
            throw KeychainError.unexpectedTokenData
        }
        
        // Decoding the data into token.
        let decoder = JSONDecoder()
        let token = try decoder.decode(Token.self, from: tokenData)
        
        return token.value
    }
    
    
    /// Deleting the token value in the Keychain.
    static func delete() throws -> OSStatus {
        // Creating a query dictionary
        // with some information about
        // how the search the token on the keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        // Deleting the dictionary with the corresponding
        // corresponding Token instance in the Keychain
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        return status
    }
}
