//
//  HabitCodable.swift
//  happit
//
//  Created by Андрей  on 22.03.2022.
//

import Foundation
import UIKit

extension HabitItem : Codable {
    private enum CodingKeys : String, CodingKey {
        case uid, title, description, priority, type, frequency, color, count, date, done_dates
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(color.rgba!, forKey: .color)
        try container.encode(count, forKey: .count)
        try container.encode(Int(date.timeIntervalSince1970), forKey: .date)
        try container.encode(description, forKey: .description)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(priority, forKey: .priority)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .uid)
        color = UIColor(rgb: (try container.decode(Int.self, forKey: .color)))
        count = try container.decode(Int.self, forKey: .count)
        date = Date(timeIntervalSince1970: (try container.decode(Double.self, forKey: .date)))
        description = try container.decode(String.self, forKey: .description)
        if let doneDatesInt = (try container.decode([Double]?.self, forKey: .done_dates)) {
            self.doneDates = doneDatesInt.map { Date(timeIntervalSince1970: $0)}
        } else {
            self.doneDates = [Date]()
        }
        frequency = try container.decode(Int.self, forKey: .frequency)
        priority = try container.decode(Priority.self, forKey: .priority)
        title = try container.decode(String.self, forKey: .title)
        type = try container.decode(Kind.self, forKey: .type)
    }
}
