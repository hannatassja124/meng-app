//
//  Activity+CoreDataProperties.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 07/08/21.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var activityDateTime: Date?
    @NSManaged public var activityDetail: String?
    @NSManaged public var activityTitle: String?
    @NSManaged public var activityType: String?
    @NSManaged public var activityReminder: Int64
    @NSManaged public var activityNotificationId: UUID?
    @NSManaged public var cats: NSSet?

}

// MARK: Generated accessors for cats
extension Activity {

    @objc(addCatsObject:)
    @NSManaged public func addToCats(_ value: Cats)

    @objc(removeCatsObject:)
    @NSManaged public func removeFromCats(_ value: Cats)

    @objc(addCats:)
    @NSManaged public func addToCats(_ values: NSSet)

    @objc(removeCats:)
    @NSManaged public func removeFromCats(_ values: NSSet)

}

extension Activity : Identifiable {

}
