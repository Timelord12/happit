//
//  HabitModel+CoreDataProperties.swift
//  happit
//
//  Created by Андрей  on 28.03.2022.
//
//

import Foundation
import CoreData


extension HabitModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitModel> {
        return NSFetchRequest<HabitModel>(entityName: "HabitModel")
    }

    @NSManaged public var color: Int64
    @NSManaged public var count: Int64
    @NSManaged public var date: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var doneDates: [Date]?
    @NSManaged public var frequency: Int64
    @NSManaged public var id: String?
    @NSManaged public var priority: Int64
    @NSManaged public var title: String?
    @NSManaged public var type: Int64

}

extension HabitModel : Identifiable {

}
