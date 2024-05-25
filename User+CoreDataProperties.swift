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

}

extension User : Identifiable {

}
