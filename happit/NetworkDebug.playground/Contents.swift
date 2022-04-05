import UIKit
import Foundation
import _Concurrency
import Network

let network = HabitsNetworkService(auth: "d71d6096-621c-4bf0-8a31-c887e7027d5e")

Task.init(priority: .userInitiated) {
//    try! await network.deleteAll()
//    for i in 1...100 {
//        let habit = HabitItem(title: "Random Habit \(i)", description: "Habit #\(i)", priority: Priority(rawValue: Int.random(in: 0...2))!, type: Kind(rawValue: Int.random(in: 0...1))!, frequency: Int.random(in: 1...i), color: UIColor(red: Double.random(in: 0.25...0.75),
//                                                                                                                                                                                                                         green: Double.random(in: 0.25...0.75),
//                                                                                                                                                                                                                         blue: Double.random(in: 0.25...0.75),
//                                                                                                                                                                                                                    alpha: 1),
//                              count: Int.random(in: 1...i), date: Date.now - TimeInterval(i), doneDates: [])
//        try! await network.addHabit(habit)
//    }
    try! await network.getHabits(orderByDate: .date, orderDir: .asc)
}






