//
//  HabitsPresenter.swift
//  happit
//
//  Created by Андрей  on 17.03.2022.
//

import Foundation
import UIKit

class HabitsPresenter : HabitsViewOutput, HabitsInteractorOutput, HabitsRouterOutput {
    weak var view : HabitsViewInput!
    var interactor : HabitsInteractorInput!
    var router : HabitsRouterInput!
    var dateOrderDir: OrderDirection = .asc
    let screenHabitsCapacity = Int(UIScreen.main.bounds.size.height / (70 * UIScreen.main.scale)) + 1
    var loadedPages = 1
    
    func unwindToMain(view: HabitsViewInput, from unwindSegue: UIStoryboardSegue) {
        router.unwindToMain(view: view, from: unwindSegue)
    }
    
    func prepare(view: HabitsViewInput, for segue: UIStoryboardSegue) {
        router.prepare(view: view, for: segue)
    }
    
    func addHabit(habit: HabitItem) {
        Task.init(priority: .userInitiated) {
            do {
                try await interactor.addHabit(habit)
                fetchMoreData()
                view.reloadData()
            } catch {
                view.showAlert(title: "Failed add habit online", message: "Changes will be saved locally", redirectToSettings: false)
            }
        }
    }
    
    func deleteHabit(at indexPath: IndexPath) {
        let habit = view.habits.remove(at: indexPath.row)
        Task.init(priority: .userInitiated) {
            do {
                try await interactor.deleteHabit(habit)
                view.deleteRow(at: indexPath)
                view.reloadData()
            } catch {
                view.showAlert(title: "Failed delete habit online", message: "Changes will be saved locally", redirectToSettings: false)
            }
        }
    }
    
    func updateHabit(at index: Int, updatedHabit: HabitItem) {
        view.habits[index] = updatedHabit
        Task.init(priority: .userInitiated) {
            do {
                try await interactor.updateHabit(updatedHabit)
                fetchMoreData()
                view.reloadData()
            } catch {
                view.showAlert(title: "Failed update habit online", message: "Changes will be saved locally", redirectToSettings: false)
            }
        }
    }
    
    func fetchMoreData(spinner: UIActivityIndicatorView? = nil, increaseLoadedPages: Bool = true) {
        Task.init(priority: .userInitiated) {
            do {
                view.habits = try await interactor.getRemoteHabits(offset: 0, limit: screenHabitsCapacity * (loadedPages + 1), orderByDate: .date, orderDir: dateOrderDir, type: nil, title: nil)
                await spinner?.stopAnimating()
                view.reloadData()
                if try await interactor.getRemoteCount() > view.habits.count {
                    loadedPages += increaseLoadedPages ? 1 : 0
                } else {
                    syncRemoteAsLocal()
                }
            } catch {
                await spinner?.stopAnimating()
                view.showAlert(title: "Failed load habits", message: "Failed load more habits from server", redirectToSettings: false)
            }
        }
    }
    
    func syncLocalAsRemote(priority: TaskPriority = .background) {
        Task.init(priority: priority) {
            do {
                try await interactor.syncLocalAsRemote()
            } catch {
                    self.view.showAlert(title: "Failed sync", message: "Failed connect to sync habits with remote server", redirectToSettings: true)
            }
        }
    }
    
    func syncRemoteAsLocal(priority: TaskPriority = .background) {
        Task.init(priority: priority) {
            do {
                try await interactor.syncRemoteAsLocal()
            } catch {
                    self.view.showAlert(title: "Failed sync", message: "Failed connect to sync habits with remote server", redirectToSettings: true)
            }
        }
    }
    
    func viewDidLoad() {
        print(UIScreen.main.bounds.size.height)
        print(UIScreen.main.scale)
        Task.init(priority: .userInitiated) {
            try await interactor.coredata.deleteAll()
        }
        syncLocalAsRemote(priority: .medium)
        fetchMoreData()
    }
    
    func dateButtonPressed() {
        view.changeDateArrow(currentDir: dateOrderDir)
        dateOrderDir = dateOrderDir == .asc ? .desc : .asc
        fetchMoreData(increaseLoadedPages: false)
    }
    
    func doneButtonPressed(habit: HabitItem) {
        Task.init(priority: .high) {
            try await self.interactor.completeHabit(habit)
            let indexOfHabit = Int(view.habits.firstIndex(of: habit)!)
            let habit = try await interactor.getLocalHabit(by: habit)
            view.habits[indexOfHabit] = habit
            view.reloadData()
            let countLeft = calculateHowMuchLeft(habit)
            let condition = countLeft <= 0
            let praise: String = { switch (habit.type, condition) {
            case (.good, false): return "You should do this \(countLeft) more times 💪"
            case (.bad, false): return "You can do this habit \(countLeft) more times 😉"
            case (.good, true): return "You are breathtaking! 🤩"
            case (.bad, true): return "Stop doing this habit ⛔️"
            }}()
            view.showAlert(title: habit.type == .good && condition ? "Great Job!" : "Habit completion", message: praise, redirectToSettings: false)
        }
    }
    
    func calculateHowMuchLeft(_ habit: HabitItem) -> Int {
        let cycles = Int(-habit.date.timeIntervalSinceNow) / (86400 * habit.frequency)
        var cyclesLeft = DateComponents()
        cyclesLeft.day = cycles * habit.frequency
        let threshold = Calendar.current.date(byAdding: cyclesLeft, to: habit.date)
        let doneCount = habit.doneDates.filter({$0 >= threshold!}).count
        return habit.count - doneCount
    }
}

protocol HabitsViewOutput : AnyObject {
    func unwindToMain(view: HabitsViewInput, from unwindSegue: UIStoryboardSegue)
    func prepare(view: HabitsViewInput, for segue: UIStoryboardSegue)
    func dateButtonPressed()
    func viewDidLoad()
    func doneButtonPressed(habit: HabitItem)
    func deleteHabit(at indexPath: IndexPath)
    func fetchMoreData(spinner: UIActivityIndicatorView?, increaseLoadedPages: Bool)
}

protocol HabitsInteractorOutput : AnyObject {
}

protocol HabitsRouterOutput : AnyObject {
    func deleteHabit(at indexPath: IndexPath)
    func updateHabit(at index: Int, updatedHabit: HabitItem)
    func addHabit(habit: HabitItem)
} 
