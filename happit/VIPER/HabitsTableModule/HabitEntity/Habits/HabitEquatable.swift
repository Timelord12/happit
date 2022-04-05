//
//  HabitItemEquitable.swift
//  happit
//
//  Created by Андрей  on 25.03.2022.
//

import Foundation

extension HabitItem : Equatable {
    static func == (lhs: HabitItem, rhs: HabitItem) -> Bool {
        return lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.priority == rhs.priority &&
        lhs.type == rhs.type &&
        lhs.frequency == rhs.frequency &&
        lhs.color == rhs.color &&
        lhs.count == rhs.count &&
        lhs.date == rhs.date &&
        lhs.doneDates == rhs.doneDates
    }
}
