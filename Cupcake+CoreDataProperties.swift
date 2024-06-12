//
//  Cupcake+CoreDataProperties.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/06/24.
//
//

import Foundation
import CoreData


extension Cupcake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cupcake> {
        return NSFetchRequest<Cupcake>(entityName: "Cupcake")
    }

    @NSManaged public var coverImage: Data?
    @NSManaged public var createAt: Date?
    @NSManaged public var flavor: String?
    @NSManaged public var id: UUID?
    @NSManaged public var ingredients: Data?
    @NSManaged public var price: Double
    @NSManaged public var orders: NSSet?

}

// MARK: Generated accessors for orders
extension Cupcake {

    @objc(addOrdersObject:)
    @NSManaged public func addToOrders(_ value: Order)

    @objc(removeOrdersObject:)
    @NSManaged public func removeFromOrders(_ value: Order)

    @objc(addOrders:)
    @NSManaged public func addToOrders(_ values: NSSet)

    @objc(removeOrders:)
    @NSManaged public func removeFromOrders(_ values: NSSet)

}

extension Cupcake : Identifiable {

}
