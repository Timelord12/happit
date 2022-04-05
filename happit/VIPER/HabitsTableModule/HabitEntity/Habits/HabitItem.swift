//
//  HabitItem.swift
//  happit
//
//  Created by Андрей  on 22.03.2022.
//

import Foundation
import UIKit

struct HabitItem {
    let id : String
    let title : String
    let description : String
    let priority : Priority
    let type : Kind
    let frequency : Int
    let color : UIColor
    let count : Int
    let date : Date
    let doneDates : [Date]
    
    init(id: String = UUID().uuidString,title: String, description: String, priority: Priority, type: Kind, frequency: Int, color: UIColor, count: Int, date: Date, doneDates: [Date]) {
        self.id = id
        self.title = title
        self.description = description
        self.priority = priority
        self.type = type
        self.frequency = frequency
        self.color = color
        self.count = count
        self.date = date
        self.doneDates = doneDates
    }
    
    static func randomHabit(title: String, date: Date) -> HabitItem {
            return HabitItem(title: title,
                             description: "Random Description",
                             priority: Priority.init(rawValue: Int.random(in: 0...2))!,
                             type: Kind.init(rawValue: Int.random(in: 0...1))!,
                             frequency: Int.random(in: 1...7),
                             color: UIColor(red: Double.random(in: 0.25...0.75),
                                            green: Double.random(in: 0.25...0.75),
                                            blue: Double.random(in: 0.25...0.75),
                                            alpha: 1),
                             count: Int.random(in: 0...10),
                             date: date,
                             doneDates: [])
    }
}
