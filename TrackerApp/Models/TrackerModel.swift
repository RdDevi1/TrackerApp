//
//  TrackerModel.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 28.03.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let label: String
    let color: UIColor
    let emoji: String
    let completedDaysCount: Int
    let schedule: [WeekDay]?
    var isPinned: Bool
    let category: TrackerCategory
    
    init(id: UUID = UUID(), color: UIColor, label: String, emoji: String, completedDaysCount: Int, schedule: [WeekDay]?, isPinned: Bool, category: TrackerCategory) {
        self.id = id
        self.color = color
        self.label = label
        self.emoji = emoji
        self.completedDaysCount = completedDaysCount
        self.schedule = schedule
        self.isPinned = isPinned
        self.category = category
    }
}
