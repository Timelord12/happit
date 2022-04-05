//
//  HabitTableCell.swift
//  happit
//
//  Created by Андрей  on 20.03.2022.
//

import UIKit

@IBDesignable class HabitTableCell: UITableViewCell {

    @IBOutlet weak var type: UIImageView!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    private var mainView: HabitsViewController!
    private var habit: HabitItem!
    private var color: UIColor? = UIColor.black
    
    @IBAction func donePressed(_ sender: Any) {
        mainView.presenter.doneButtonPressed(habit: habit)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func makeGoodType(imageView view: UIImageView) {
        view.image = UIImage.init(systemName: "checkmark.seal.fill")
        view.tintColor = .systemGreen
    }
    
    func makeBadType(imageView view: UIImageView) {
        view.image = UIImage.init(systemName: "clear.fill")
        view.tintColor = .systemRed
    }
    
    func set(habit: HabitItem, sender: HabitsViewController) {
        self.mainView = sender
        self.habit = habit
        color = habit.color
        title.text = habit.title
        title.textColor = color
        doneButton.tintColor = color
        descriptionText.text = habit.description
        frequency.text = "every \(habit.frequency) days"
        priority.text = {
            switch habit.priority {
            case .middle: return "❗️"
            case .high: return "‼️"
            case .low: return "🥱"
            }
        }()
        switch habit.type {
            case .bad: makeBadType(imageView: type)
            case .good: makeGoodType(imageView: type)
        }
    }
}
