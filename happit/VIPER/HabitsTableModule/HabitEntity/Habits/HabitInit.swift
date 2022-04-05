//
//  HabitItemExtension.swift
//  happit
//
//  Created by Андрей  on 22.03.2022.
//

import Foundation
import UIKit

extension HabitItem {
    init(withBuilder builder: HabitItemBuilder) {
        self.id = builder.id
        self.title = builder.title
        self.description = builder.description
        self.priority = builder.priority
        self.type = builder.type
        self.frequency = builder.frequency
        self.color = builder.color
        self.count = builder.count
        self.date = builder.date
        self.doneDates = builder.doneDates
    }
    
    init(withModel model: HabitModel) {
        self.id = model.id!
            self.title = model.title!
            self.description = model.descriptionText!
            self.priority = Priority.init(rawValue: Int(model.priority))!
            self.type = Kind.init(rawValue: Int(model.type))!
            self.frequency = Int(model.frequency)
            self.color = UIColor(rgb: Int(model.color))
            self.count = Int(model.count)
            self.date = model.date!
            self.doneDates = model.doneDates!
    }
}
