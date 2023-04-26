//
//  TrackerRecord.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 29.03.2023.
//

import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let trackerId: UUID
    let date: Date
    
    init(id: UUID = UUID(), trackerId: UUID, date: Date) {
        self.id = id
        self.trackerId = trackerId
        self.date = date
    }
}
