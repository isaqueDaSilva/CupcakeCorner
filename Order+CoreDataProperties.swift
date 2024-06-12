//
//  Order+CoreDataProperties.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 09/06/24.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var userName: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var addSprinkles: Bool
    @NSManaged public var extraFrosting: Bool
    @NSManaged public var finalPrice: Double
    @NSManaged public var status: String?
    @NSManaged public var orderTime: Date?
    @NSManaged public var outForDelivery: Date?
    @NSManaged public var deliveredTime: Date?
    @NSManaged public var cupcake: Cupcake?

}

extension Order : Identifiable {

}
