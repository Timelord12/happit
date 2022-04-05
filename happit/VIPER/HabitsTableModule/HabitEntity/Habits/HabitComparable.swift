//
//  HabitComparable.swift
//  happit
//
//  Created by Андрей  on 26.03.2022.
//

import Foundation

extension HabitItem : Comparable {
    static func < (lhs: HabitItem, rhs: HabitItem) -> Bool {
        lhs.date < rhs.date
    }
}
