//
//  User+CoreDataProperties.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 24/05/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var role: String?
    @NSManaged public var paymentMethod: String?
    @NSManaged public var fullAdress: String?
    @NSManaged public var city: String?
    @NSManaged public var zip: String?
    
    public var wrappedName: String {
        name ?? "No name saved"
    }
    
    public var wrappedEmail: String {
        email ?? "No email saved."
    }
    
    public var wrappedRole: String {
        role ?? "No role saved"
    }
    
    public var wrappedPaymentMethod: String {
        guard let paymentMethod else {
            return PaymentMethod.cash.displayedName
        }
        
        let method = PaymentMethod(rawValue: paymentMethod)
        
        guard let method else {
            return PaymentMethod.cash.displayedName
        }
        
        return method.displayedName
    }
    
    public var wrappedAdress: String {
        "\(fullAdress ?? "No adress saved."), \(city ?? "No city saved"), \(zip ?? "No zip saved")."
    }
}

extension User : Identifiable {

}
