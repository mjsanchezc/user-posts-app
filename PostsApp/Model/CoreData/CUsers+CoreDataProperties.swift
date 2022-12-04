//
//  CUsers+CoreDataProperties.swift
//  PostsApp
//
//  Created by Maria Jose Sanchez Cairazco on 4/12/22.
//
//

import Foundation
import CoreData

extension CUsers {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CUsers> {
        return NSFetchRequest<CUsers>(entityName: "CUsers")
    }

    @NSManaged public var email: String?
    @NSManaged public var userId: Int16
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
}

extension CUsers : Identifiable {

}
