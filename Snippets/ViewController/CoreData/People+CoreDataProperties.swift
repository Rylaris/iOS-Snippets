//
//  People+CoreDataProperties.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/26.
//
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var age: Int16
    @NSManaged public var name: String?

}

extension People : Identifiable {

}
