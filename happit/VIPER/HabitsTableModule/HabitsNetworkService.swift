//
//  HabitsNetworkService.swift
//  happit
//
//  Created by Андрей  on 17.03.2022.
//

import Foundation


class HabitsNetworkService {
    init(auth: String = "065df4d2-afb4-4c73-a5bc-8e3cf57b76b8") {
        self.auth = auth
    }
    private var auth: String
    private func apiRequest(queryItems qI: [URLQueryItem]? = nil, path : String = "/api/habits") -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "habits-internship.doubletapp.ai"
        components.path = path
        if let qI = qI {
            components.queryItems = qI
        }
        var request = URLRequest(url: components.url!)
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func connectServer(method: HTTPMethod, queryItems: [URLQueryItem]? = nil, path: String = "/api/habits", body: Data? = nil) async throws -> (data: Data, responce: URLResponse, statusCode: Int) {
        var request = apiRequest(queryItems: queryItems, path: path)
        request.httpMethod = method.rawValue
        request.httpBody = body
        let (data, responce) = try await URLSession.shared.data(for: request)
        let httpResponce = responce as? HTTPURLResponse
        guard let statusCode = httpResponce?.statusCode else { throw NetworkError.connectionError }
        return (data: data, responce: responce, statusCode: statusCode)
    }
    
    private struct HabitsGetJSON : Codable {
        var count: Int
        var habits: [HabitItem]
        
        private enum CodingKeys : String, CodingKey {
            case count, habits
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            count = try container.decode(Int.self, forKey: .count)
            if let habits = try? container.decode([HabitItem].self, forKey: .habits) {
                self.habits = habits
            } else {
                self.habits = [HabitItem]()
            }
        }
    }
    
    func getHabits(offset: Int = 0, limit: Int = -1, orderByDate: OrderByDate? = nil, orderDir: OrderDirection? = nil, type: Kind? = nil, title: String? = nil, returnCount: Bool = false) async throws -> [HabitItem] {
        var queryItems = [
            URLQueryItem(name: "offset", value: offset.description),
            URLQueryItem(name: "limit", value: limit.description)
        ]
        if let orderDir = orderDir { queryItems.append(URLQueryItem(name: "order_direction", value: orderDir.rawValue)) }
        if let title = title { queryItems.append(URLQueryItem(name: "title", value: title)) }
        if let orderByDate = orderByDate { queryItems.append(URLQueryItem(name: "order_by", value: orderByDate.rawValue)) }
        if let type = type { queryItems.append(URLQueryItem(name: "type", value: type.rawValue.description)) }
        
        let results = try await connectServer(method: .get, queryItems: queryItems)
        guard results.statusCode == 200 else { throw NetworkError.fetchError(results.statusCode) }
        let json = try JSONDecoder().decode(HabitsGetJSON.self, from: results.data)
        return json.habits
    }
    
    func getCount() async throws -> Int {
        let result = try await connectServer(method: .get, queryItems: [URLQueryItem(name: "limit", value: "-1")])
        guard result.statusCode == 200 else {
            throw NetworkError.fetchError(result.statusCode)
        }
        let json = try JSONDecoder().decode(HabitsGetJSON.self, from: result.data)
        return json.count
    }
    
    func addHabit(_ habit: HabitItem) async throws -> HabitItem {
        let results = try await connectServer(method: .post, body: try JSONEncoder().encode(habit))
        guard results.statusCode == 200 else {
            throw NetworkError.addError(results.statusCode) }
        let habit = try JSONDecoder().decode(HabitItem.self, from: results.data)
        return habit
    }
    
    func deleteHabit(_ habit: HabitItem) async throws {
        let results = try await connectServer(method: .delete, path: "/api/habits/\(habit.id)")
        guard results.statusCode == 200 else { throw NetworkError.deleteError(results.statusCode) }
    }
    
    func deleteAll() async throws {
        let habits = try await getHabits()
        for habit in habits {
            try await deleteHabit(habit)
        }
    }
    
    func updateHabit(_ habit: HabitItem) async throws {
        let results = try await connectServer(method: .patch, path: "/api/habits/\(habit.id)", body: try JSONEncoder().encode(habit))
        guard results.statusCode == 200 else {
            print(String(data: results.data, encoding: .utf8)!)
            throw NetworkError.updateError(results.statusCode) }
    }
    
    func completeHabit(_ habit: HabitItem, date: Date) async throws {
        let results = try await connectServer(method: .post, path: "/api/habits/\(habit.id)/complete", body: JSONSerialization.data(withJSONObject: ["date": Int(date.timeIntervalSince1970)], options: []))
        guard results.statusCode == 200 else {
            throw NetworkError.completeError(results.statusCode) }
    }
}
