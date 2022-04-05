//
//  HabitsCoreDataService.swift
//  happit
//
//  Created by Андрей  on 17.03.2022.
//

import Foundation
import UIKit
import CoreData

class HabitsCoreDataService {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func fetchHabitModel(by habit: HabitItem) async throws -> HabitModel {
        return try await context.perform {
            let fetchRequest = HabitModel.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", habit.id)
            guard let model = try? self.context.fetch(fetchRequest).first
            else {
                throw CoreDataError.fetchError
            }
            return model
        }
    }
    
    func fetchHabitItem(by habit: HabitItem) async throws -> HabitItem {
        return try await context.perform {
            let fetchRequest = HabitModel.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", habit.id)
            guard let model = try? self.context.fetch(fetchRequest).first
            else {
                throw CoreDataError.fetchError
            }
            return HabitItem(withModel: model)
        }
    }
    
    private func delete(model: HabitModel) async throws {
        await context.perform {
            self.context.delete(model)
        }
        try await self.save()
    }
    
    private func save() async throws {
        try await context.perform {
            do {
                try self.context.save()
            } catch {
                throw CoreDataError.saveError
            }
        }
    }
    
    public func addHabit(_ habit: HabitItem) async throws {
        HabitModel(habit: habit, context: context)
        try await save()
    }
    
    public func updateHabit(_ newHabit: HabitItem, oldHabit: HabitItem? = nil) async throws {
        let model = try await fetchHabitModel(by: oldHabit == nil ? newHabit : oldHabit!)
        try await delete(model: model)
        try await addHabit(newHabit)
        try await save()
    }
    
    public func deleteHabit(_ habit: HabitItem) async throws {
        let model = try await fetchHabitModel(by: habit)
        try await delete(model: model)
        try await save()
    }
    
    public func deleteAll() async throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: HabitModel.fetchRequest())
        do { try context.execute(deleteRequest) }
        catch { throw CoreDataError.deleteAllError }
        try await save()
    }
    
    public func getHabits(limit: Int = -1, offset: Int = 0) async throws -> [HabitItem] {
        return try await context.perform {
            let request = HabitModel.fetchRequest()
            request.fetchLimit = limit
            request.fetchOffset = offset
            guard let models = try? self.context.fetch(request)
            else {
                throw CoreDataError.fetchError
            }
            return models.map {HabitItem(withModel: $0)}
        }
    }
    
    public func completeHabit(_ habit: HabitItem) async throws {
        let habitBuilder = HabitItemBuilder(habit)
        habitBuilder.doneDates.append(Date.now)
        let habitCompleted = HabitItem(withBuilder: habitBuilder)
        try await updateHabit(habitCompleted)
    }
}
