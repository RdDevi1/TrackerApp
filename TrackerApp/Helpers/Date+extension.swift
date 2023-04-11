//
//  Date+extension.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 06.04.2023.
//

import Foundation


extension Date {
    
    func onlyDate() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}

extension Calendar {
    static let mondayFirst: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // понедельник
        calendar.locale = Locale(identifier: "ru_RU")
        return calendar
    }()
}

