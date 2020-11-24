//
//  Singer+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Avery Vine on 2020-11-24.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

}

extension Singer : Identifiable {

}

extension Singer {
    var wrappedFirstName: String {
        firstName ?? "Unknown"
    }
    
    var wrappedLastName: String {
        lastName ?? "Unknown"
    }
}
