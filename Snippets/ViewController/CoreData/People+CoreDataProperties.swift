//
//  People+CoreDataProperties.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/26.
//
//

import Foundation
import CoreData

protocol Managed: NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name!
    }
}


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var age: Int16
    @NSManaged public var name: String?
    
    static func insert(into context: NSManagedObjectContext, age: Int16, name: String) -> People {
        let people: People = context.insertObject()
        people.age = age
        people.name = name
        return people
    }

}

extension People : Identifiable {

}

extension People: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(keyPath: \People.name, ascending: true)]
    }
}
