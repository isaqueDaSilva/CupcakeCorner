//
//  Cupcake+CoreDataProperties.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 24/05/24.
//
//

import Foundation
import CoreData
import UIKit


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
    
    public var wrappedCoverImage: UIImage? {
        guard let coverImage else {
            return UIImage(systemName: Icon.questionmarkDiamond.rawValue)
        }
        
        return UIImage(data: coverImage)
    }
    
    public var wrappedFlavor: String {
        flavor ?? "No flavor saved"
    }
    
    public var wrappedIngredients: [String] {
        guard let ingredients else {
            return []
        }
        
        let ingredientsArray = ingredients.map { String($0) }
        
        print(ingredientsArray)
        return ingredientsArray
    }
    
    public var wrappedCreationDate: Date {
        createAt ?? .now
    }
}

extension Cupcake : Identifiable {

}
