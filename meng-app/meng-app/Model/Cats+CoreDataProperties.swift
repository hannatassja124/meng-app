//
//  Cats+CoreDataProperties.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 25/07/21.
//
//

import Foundation
import CoreData


extension Cats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cats> {
        return NSFetchRequest<Cats>(entityName: "Cats")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: Int16
    @NSManaged public var race: String?
    @NSManaged public var isNeutered: Bool
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var weight: Double
    @NSManaged public var vetName: String?
    @NSManaged public var vetPhoneNo: String?
    @NSManaged public var food: String?
    @NSManaged public var allergies: String?
    @NSManaged public var activities: NSSet?

}

// MARK: Generated accessors for activities
extension Cats {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}

extension Cats : Identifiable {

}
