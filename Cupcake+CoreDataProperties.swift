//
//  Cupcake+CoreDataProperties.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 24/05/24.
//
//

import Foundation
import CoreData


extension Cupcake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cupcake> {
        return NSFetchRequest<Cupcake>(entityName: "Cupcake")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var coverImage: Data?
    @NSManaged public var flavor: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var price: Double
    @NSManaged public var createAt: Date?

}

extension Cupcake : Identifiable {

}
