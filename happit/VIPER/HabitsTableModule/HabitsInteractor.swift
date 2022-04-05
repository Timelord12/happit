//
//  HabitsInteractor.swift
//  happit
//
//  Created by Андрей  on 17.03.2022.
//

import Foundation
import Network

class HabitsInteractor : HabitsInteractorInput {
    weak var presenter: HabitsInteractorOutput!
    var network: HabitsNetworkService
    var coredata: HabitsCoreDataService
    
    func getLocalHabit(by habit: HabitItem) async throws -> HabitItem  {
        return try await coredata.fetchHabitItem(by: habit)
    }
    
    func addHabit(_ habit: HabitItem) async throws {
        do {
            try await coredata.addHabit(habit)
            let idhabit = try await network.addHabit(habit)
            try await coredata.updateHabit(idhabit, oldHabit: habit)
        } catch {
            try await coredata.addHabit(habit)
            throw NetworkError.connectionError
        }
    }
    
    func deleteHabit(_ habit: HabitItem) async throws {
        do {
            try await network.deleteHabit(habit)
            try await coredata.deleteHabit(habit)
        } catch {
            try await coredata.deleteHabit(habit)
            throw NetworkError.connectionError
        }
    }
    
    func updateHabit(_ habit: HabitItem) async throws {
        do {
            try await network.updateHabit(habit)
            try await coredata.updateHabit(habit)
        } catch {
            try await coredata.updateHabit(habit)
            throw NetworkError.connectionError
        }
    }
    
    func completeHabit(_ habit: HabitItem) async throws {
        do {
            try await network.completeHabit(habit, date: Date.now)
            try await coredata.completeHabit(habit)
        } catch {
            try await coredata.completeHabit(habit)
            throw NetworkError.connectionError
        }
    }
    
    func getLocalHabits(orderDir: OrderDirection, limit: Int = -1, offset: Int = 0) async throws -> [HabitItem] {
        var habits = try await coredata.getHabits(limit: limit, offset: offset)
        habits.sort()
        if orderDir == .asc {
            return habits
        } else {
            habits.reverse()
            return habits
        }
    }
    
    func getRemoteHabits(offset: Int = 0, limit: Int = -1, orderByDate: OrderByDate? = nil, orderDir: OrderDirection? = nil, type: Kind? = nil, title: String? = nil) async throws -> [HabitItem] {
        return try await network.getHabits(offset: offset, limit: limit, orderByDate: orderByDate, orderDir: orderDir, type: type, title: title)
    }
    
    func getRemoteHabits() async throws -> [HabitItem] {
        return try await network.getHabits()
    }
    
    func getRemoteCount() async throws -> Int {
        return try await network.getCount()
    }
    
    func compareDataBases(oldBase: [HabitItem], newBase: [HabitItem]) -> (toDelete: [HabitItem], toUpdate: [HabitItem], toAdd: [HabitItem]) {
        let newBaseDifference = newBase / oldBase
        var toDelete = oldBase / newBase
        var toAdd = [HabitItem]()
        var toUpdate = [HabitItem]()
        
        for element in newBaseDifference {
            if (toDelete.map {$0.id}).contains(element.id) {
                toUpdate.append(element)
                toDelete.removeAll(where:) {$0.id == element.id}
            } else {
                toAdd.append(element)
            }
        }
        
        return (toDelete: toDelete, toUpdate: toUpdate, toAdd: toAdd)
    }
    
    func syncRemoteAsLocal() async throws {
        let localData = try await coredata.getHabits()
        let remoteData = try await network.getHabits()
        let tasks = compareDataBases(oldBase: remoteData, newBase: localData)
        
        for habit in tasks.toDelete {
            try await network.deleteHabit(habit)
        }
        
        for habit in tasks.toAdd {
            let returnedHabit = try await network.addHabit(habit)
            try await coredata.updateHabit(returnedHabit, oldHabit: habit)
        }
        
        for habit in tasks.toUpdate {
            let remoteVersion = remoteData.first(where:) {$0.id == habit.id}!
            let newDoneDates = habit.doneDates.difference(from: remoteVersion.doneDates)
            for date in newDoneDates { try await network.completeHabit(habit, date: date) }
            if habit.date > remoteVersion.date { try await network.updateHabit(habit) }
        }
    }
    
    func syncLocalAsRemote() async throws {
        let localData = try await coredata.getHabits()
        let remoteData = try await network.getHabits()
        let tasks = compareDataBases(oldBase: localData, newBase: remoteData)
        
        for habit in tasks.toUpdate {
            try await coredata.updateHabit(habit)
        }
        
        for habit in tasks.toDelete {
            try await coredata.deleteHabit(habit)
        }
        
        for habit in tasks.toAdd {
            try await coredata.addHabit(habit)
        }
    }
    
    init(network: HabitsNetworkService, coredata: HabitsCoreDataService) {
        self.network = network
        self.coredata = coredata
    }
}

protocol HabitsInteractorInput : AnyObject {
    //fast user init func
    func getLocalHabit(by habit: HabitItem) async throws -> HabitItem  
    func getLocalHabits(orderDir: OrderDirection, limit: Int, offset: Int) async throws -> [HabitItem]
    func getRemoteHabits(offset: Int, limit: Int, orderByDate: OrderByDate?, orderDir: OrderDirection?, type: Kind?, title: String?) async throws -> [HabitItem]
    func getRemoteHabits() async throws -> [HabitItem]
    func addHabit(_ habit: HabitItem) async throws
    func deleteHabit(_ habit: HabitItem) async throws
    func updateHabit(_ habit: HabitItem) async throws
    func completeHabit(_ habit: HabitItem) async throws
    func getRemoteCount() async throws -> Int
    
    //slow global background only functions
    func syncRemoteAsLocal() async throws
    func syncLocalAsRemote() async throws
    var coredata: HabitsCoreDataService {get set}
}
