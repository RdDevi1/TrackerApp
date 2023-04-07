//
//  TrackerCategory.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 29.03.2023.
//

import UIKit

struct TrackerCategory {
    var label: String
    var trackers: [Tracker]
}

var mockData: [TrackerCategory] = [
        TrackerCategory(
            label: "Домашний уют",
            trackers: [
                Tracker(color: UIColor(named: "Color selection 5")!,
                        label: "Поливать растения",
                        emoji: "❤️",
                        schedule: [.saturday]
                       )
            ]
        ),

        TrackerCategory(
            label: "Радостные мелочи",
            trackers: [
                Tracker(color: UIColor(named: "Color selection 2")!,
                        label: "Кошка заслонила камеру на созвоне",
                        emoji: "😻",
                        schedule: nil
                       ),

                Tracker(color: UIColor(named: "Color selection 1")!,
                        label: "Бабушка прислала открытку в вотсапе",
                        emoji: "🌺",
                        schedule: nil
                       ),

                Tracker(color: UIColor(named: "Color selection 14")!,
                        label: "Свидания в апреле",
                        emoji: "❤️",
                        schedule: nil
                       ),
            ]
        )
    ]

