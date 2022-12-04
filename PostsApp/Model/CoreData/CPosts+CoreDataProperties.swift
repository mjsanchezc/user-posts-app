//
//  CPosts+CoreDataProperties.swift
//  PostsApp
//
//  Created by Maria Jose Sanchez Cairazco on 4/12/22.
//
//

import Foundation
import CoreData

extension CPosts {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CPosts> {
        return NSFetchRequest<CPosts>(entityName: "CPosts")
    }

    @NSManaged public var body: String?
    @NSManaged public var postId: Int16
    @NSManaged public var title: String?
    @NSManaged public var userId: Int16
}

extension CPosts : Identifiable {

}
