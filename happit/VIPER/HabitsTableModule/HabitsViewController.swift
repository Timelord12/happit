//
//  HabitsTableViewController.swift
//  happit
//
//  Created by Андрей  on 17.03.2022.
//

import Foundation
import UIKit

class HabitsViewController : UIViewController, HabitsViewInput {
    var presenter: HabitsViewOutput!
    var habits = [HabitItem]()
    
    @IBOutlet weak var dateButton: UIBarButtonItem!
    @IBAction func dateButtonPressed(_ sender: UIBarButtonItem) {
        presenter.dateButtonPressed()
    }
    
    var habitsTableView = HabitsTableViewController()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HabitsAssembler.createModuleFromView(view: self)
        habitsTableView.mainView = self
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = habitsTableView
        tableView.dataSource = habitsTableView
        presenter.viewDidLoad()
    }
    
    func changeDateArrow(currentDir: OrderDirection) {
        DispatchQueue.main.async {
            let newImage = currentDir == .asc ? UIImage(systemName: "arrow.down") : UIImage(systemName: "arrow.up")
            self.dateButton.image = newImage
        }
    }
    
    func showAlert(title: String, message: String, redirectToSettings: Bool) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .default, handler: {_ in })
            alert.addAction(okayAction)
            guard redirectToSettings, let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                return}
            let settingsAction = UIAlertAction(title: "Settings", style: .default) {_ in
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, options: [:])
                }
            }
            alert.addAction(settingsAction)
            self.present(alert, animated: true)
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func deleteRow(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func unwindSegueToMain(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        presenter.unwindToMain(view: self, from: unwindSegue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(view: self, for: segue)
    }
}

protocol HabitsViewInput : AnyObject {
    var habits: [HabitItem] {get set}
    func showAlert(title: String, message: String, redirectToSettings: Bool)
    func changeDateArrow(currentDir: OrderDirection)
    func reloadData()
    func deleteRow(at indexPath: IndexPath)
    var tableView: UITableView! {get set}
}
