//
//  AddHabitRouter.swift
//  happit
//
//  Created by Андрей  on 31.03.2022.
//

import Foundation
import UIKit

class AddHabitRouter: AddHabitRouterInput {
    weak var presenter: AddHabitRouterOutput!
    
    func prepare(view: AddHabitViewInput) -> HabitItem {
        let viewController = view as! AddHabitViewController
        let title = viewController.habitTitle.text!
        let description = viewController.habitDescription.text!
        let priorityTitle = viewController.priorityMenu.menu?.selectedElements.first?.title
        let priority = { () -> Priority in
            switch priorityTitle {
            case "Middle": return Priority.middle
            case "High": return Priority.high
            case "Low": return Priority.low
            default: return Priority.low
            }
        }()
        let type = Kind(rawValue: viewController.typeSwitcher.selectedSegmentIndex)!
        let color = viewController.color.selectedColor ?? UIColor.systemBlue
        let count = Int(viewController.count.text!)!
        let frequency = Int(viewController.frequency.text!)!
        
        let habit = HabitItem(id: viewController.title == "Edit Habit" ? viewController.habit.id : UUID().uuidString, title: title, description: description, priority: priority, type: type, frequency: frequency, color: color, count: count, date: Date.now, doneDates: viewController.title == "Edit Habit" ? viewController.habit.doneDates : [])
        return habit
    }
}

protocol AddHabitRouterInput: AnyObject {
    var presenter: AddHabitRouterOutput! {get set}
    func prepare(view: AddHabitViewInput) -> HabitItem
}
