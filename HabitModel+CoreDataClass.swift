//
//  HabitModel+CoreDataClass.swift
//  happit
//
//  Created by Андрей  on 28.03.2022.
//
//

import Foundation
import CoreData


public class HabitModel: NSManagedObject {
    @discardableResult convenience init(habit: HabitItem, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = habit.title
        self.descriptionText = habit.description
        self.doneDates = habit.doneDates
        self.frequency = Int64(habit.frequency)
        self.priority = Int64(habit.priority.rawValue)
        self.type = Int64(habit.type.rawValue)
        self.color = Int64(habit.color.rgba!)
        self.count = Int64(habit.count)
        self.date = habit.date
        self.id = habit.id
    }
}
