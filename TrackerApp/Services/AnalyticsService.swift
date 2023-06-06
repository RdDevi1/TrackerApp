//
//  AnalyticsService.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 05.06.2023.
//

import Foundation
import YandexMobileMetrica

enum Events: String {
    case click = "click"
    case open = "open"
    case close = "close"
}

enum Screens: String {
    case main = "Main"
}

enum Items: String {
    case add_track = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}


struct AnalyticsService {
    static func initAppMetrica() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "0a31c8cf-2408-4a0b-8e38-04f201cc06fb") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    
    func reportEvent(event: Events, onItem: Items) {
        let params = ["Item" : onItem.rawValue]
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func reportScreen(event: Events, onScreen: Screens) {
        let params = ["screen" : onScreen.rawValue]
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
}
