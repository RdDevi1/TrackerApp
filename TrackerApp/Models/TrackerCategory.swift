//
//  TrackerCategory.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 29.03.2023.
//

import UIKit

struct TrackerCategory: Equatable {
    let id: UUID
    var label: String
    
    init(id: UUID = UUID(), label: String) {
        self.id = id
        self.label = label
    }
}


