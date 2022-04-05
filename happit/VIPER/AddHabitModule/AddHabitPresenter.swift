//
//  AddHabitPresenter.swift
//  happit
//
//  Created by Андрей  on 31.03.2022.
//

import Foundation

class AddHabitPresenter: AddHabitViewOutput, AddHabitRouterOutput {
    weak var view: AddHabitViewInput!
    var router: AddHabitRouterInput = AddHabitRouter()
    
    func setEditingStyle(habit: HabitItem) {
        view.habit = habit
        view.deleteButtonAvailable = true
    }
    
    func viewDidLoad() {
        router.presenter = self
        view.updateSaveButtonState()
        if view.title == "Edit Habit" {
            view.updateUI()
        }
    }
    
    func prepare() -> HabitItem {
        return router.prepare(view: view)
    }
}

protocol AddHabitViewOutput: AnyObject {
    var view: AddHabitViewInput! {get set}
    func viewDidLoad()
    func prepare() -> HabitItem
    func setEditingStyle(habit: HabitItem)
}

protocol AddHabitRouterOutput: AnyObject {
}
