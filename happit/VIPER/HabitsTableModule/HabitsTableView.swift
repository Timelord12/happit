//
//  HabitsTableView.swift
//  happit
//
//  Created by Андрей  on 27.03.2022.
//

import Foundation
import UIKit

class HabitsTableViewController: UITableViewController {
    var mainView: HabitsViewController!
    var footerSpinner = UIActivityIndicatorView()
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        50
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerSpinner
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height, !footerSpinner.isAnimating {
            footerSpinner.startAnimating()
            mainView.presenter.fetchMoreData(spinner: footerSpinner, increaseLoadedPages: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HabitTableCell", owner: self, options: nil)?.first as! HabitTableCell
        cell.set(habit: mainView.habits[indexPath.row], sender: mainView)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainView.habits.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainView.performSegue(withIdentifier: "cellSegue", sender: mainView)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        mainView.presenter.deleteHabit(at: indexPath)
    }
}
