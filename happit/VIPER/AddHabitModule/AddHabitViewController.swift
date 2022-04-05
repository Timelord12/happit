//
//  AddHabitViewController.swift
//  happit
//
//  Created by Андрей  on 31.03.2022.
//

import Foundation
import UIKit

class AddHabitViewController: UITableViewController, AddHabitViewInput {
    @IBOutlet weak var habitTitle: UITextField!
    @IBOutlet weak var habitDescription: UITextField!
    @IBOutlet weak var typeSwitcher: UISegmentedControl!
    @IBOutlet weak var color: UIColorWell!
    @IBOutlet weak var count: UITextField!
    @IBOutlet weak var frequency: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    var habit: HabitItem!
    var presenter: AddHabitViewOutput = AddHabitPresenter()
    @IBOutlet weak var priorityMenu: UIButton!
    var deleteButtonAvailable: Bool = false
    
    override func viewDidLoad() {
        presenter.view = self
        configurePriorityMenu(sender: priorityMenu)
        self.hideKeyboardWhenTappedAround()
        presenter.viewDidLoad()
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3 + (deleteButtonAvailable ? 1 : 0)
    }
    
    private func updateActionState(actionTitle: String? = nil, menu: UIMenu) -> UIMenu {
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    action.state = .on
                }
            }
        } else {
            let action = menu.children.first as? UIAction
            action?.state = .on
        }
        return menu
    }
    
    func updateSaveButtonState() {
        if !habitTitle.text!.isEmpty, !habitDescription.text!.isEmpty,
           let count = Int(count.text!), let frequency = Int(frequency.text!),
            count > 0, frequency > 0 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func updateUI() {
        habitTitle.text = habit.title
        habitDescription.text = habit.description
        typeSwitcher.selectedSegmentIndex = habit.type == .good ? 0 : 1
        color.selectedColor = habit.color
        count.text = String(habit.count)
        frequency.text = String(habit.frequency)
        let activePriority = { () -> String in
            switch habit.priority {
            case .middle: return "Middle"
            case .high: return "High"
            case .low: return "Low"
            }
        }()
        priorityMenu.menu = updateActionState(actionTitle: activePriority, menu: priorityMenu.menu!)
    }
    
    private func configurePriorityMenu(sender: UIButton) {
        let menuItems = [
            UIAction(title:"Low", handler: {_ in
            
            }),
            UIAction(title: "Middle", handler: {_ in
                
            }),
            UIAction(title: "High", handler: {_ in })
        ]
        let menu = UIMenu(title: "Priority", children: menuItems)
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
        sender.changesSelectionAsPrimaryAction = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }
        self.habit = presenter.prepare()
    }
}

protocol AddHabitViewInput: AnyObject {
    var title: String? {get set}
    var deleteButtonAvailable: Bool {get set}
    var habit: HabitItem! {get set}
    func updateSaveButtonState()
    func updateUI()
}
