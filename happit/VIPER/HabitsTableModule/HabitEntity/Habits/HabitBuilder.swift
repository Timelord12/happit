//
//  HabitBuilder.swift
//  happit
//
//  Created by Андрей  on 22.03.2022.
//

import Foundation
import UIKit

class HabitItemBuilder {
    let id : String
    var title : String
    var description : String
    var priority : Priority
    var type : Kind
    var frequency : Int
    var color : UIColor
    var count : Int
    var date : Date
    var doneDates : [Date]
    
    init(_ habit: HabitItem) {
        self.id = habit.id
        self.priority = habit.priority
        self.doneDates = habit.doneDates
        self.title = habit.title
        self.description = habit.description
        self.color = habit.color
        self.type = habit.type
        self.count = habit.count
        self.frequency = habit.frequency
        self.date = habit.date
    }
    
    init() {
        self.id = UUID().uuidString
        self.title = ""
        self.description = ""
        self.priority = .middle
        self.type = .good
        self.frequency = 0
        self.color = UIColor.black
        self.count = 0
        self.date = Date.now
        self.doneDates = []
    }
}
