//
//  TrackerCategory.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 29.03.2023.
//

import UIKit

struct TrackerCategory {
    let id: UUID
    let label: String
    
    init(id: UUID = UUID(), label: String) {
        self.id = id
        self.label = label
    }
}

//var mockData: [TrackerCategory] = [
//        TrackerCategory(
//            label: "Домашний уют",
//            trackers: [
//                Tracker(color: UIColor(named: "Color selection 5")!,
//                        label: "Поливать растения",
//                        emoji: "❤️",
//                        schedule: [.saturday]
//                       )
//            ]
//        ),
//
//        TrackerCategory(
//            label: "Радостные мелочи",
//            trackers: [
//                Tracker(color: UIColor(named: "Color selection 2")!,
//                        label: "Кошка заслонила камеру на созвоне",
//                        emoji: "😻",
//                        schedule: nil
//                       ),
//
//                Tracker(color: UIColor(named: "Color selection 1")!,
//                        label: "Бабушка прислала открытку в вотсапе",
//                        emoji: "🌺",
//                        schedule: nil
//                       ),
//
//                Tracker(color: UIColor(named: "Color selection 14")!,
//                        label: "Свидания в апреле",
//                        emoji: "❤️",
//                        schedule: nil
//                       ),
//            ]
//        )
//    ]

