//
//  HabitsRouter.swift
//  happit
//
//  Created by Андрей  on 17.03.2022.
//

import Foundation
import UIKit

class HabitsRouter : HabitsRouterInput {
    weak var presenter : HabitsRouterOutput!

    func unwindToMain(view: HabitsViewInput, from unwindSegue: UIStoryboardSegue) {
        let view = view as! HabitsViewController
        guard unwindSegue.identifier != "cancelSegue" else { return }
        let sourceVC = unwindSegue.source as! AddHabitViewController
        let habit = sourceVC.habit!
        
        if let selectedIndexPath = view.tableView.indexPathForSelectedRow {
            if unwindSegue.identifier == "deleteSegue" {
                presenter.deleteHabit(at: selectedIndexPath)
            } else {
                presenter.updateHabit(at: selectedIndexPath.row, updatedHabit: habit)
            }
        } else {
            presenter.addHabit(habit: habit)
        }
    }
    
    func prepare(view: HabitsViewInput, for segue: UIStoryboardSegue) {
        let view = view as! HabitsViewController
        guard segue.identifier == "cellSegue" else { return }
        let indexPath = view.tableView.indexPathForSelectedRow!
        let habit = view.habits[indexPath.row]
        let navVC = segue.destination as! UINavigationController
        let addHabitVC = navVC.topViewController as! AddHabitViewController
        addHabitVC.presenter.view = addHabitVC
        addHabitVC.presenter.setEditingStyle(habit: habit)
        addHabitVC.title = "Edit Habit"
    }
}

protocol HabitsRouterInput : AnyObject {
    func unwindToMain(view: HabitsViewInput, from unwindSegue: UIStoryboardSegue)
    func prepare(view: HabitsViewInput, for segue: UIStoryboardSegue)
}
