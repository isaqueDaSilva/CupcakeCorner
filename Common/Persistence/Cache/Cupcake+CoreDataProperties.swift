//
//  Cupcake+CoreDataProperties.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 28/05/24.
//
//

import Foundation
import CoreData
import UIKit


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
        
        let decoder = JSONDecoder()
        
        guard let ingredientsArray = try? decoder.decode([String].self, from: ingredients) else {
            return []
        }
        
        print(ingredientsArray)
        return ingredientsArray
    }
    
    public var wrappedCreationDate: Date {
        createAt ?? .now
    }
}

extension Cupcake : Identifiable {

}
