//
// Created by Андрей Парамонов on 25.11.2023.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    private static var isActivated = false

    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "219114e7-45d6-43b9-a643-4a2e6707179a") else { return }
        YMMYandexMetrica.activate(with: configuration)
        isActivated = true
    }

    func report(name: String, event: Event, screen: Screen, item: Item?) {
        if !AnalyticsService.isActivated { return }
        var params: [String: Any] = [
            "event": event.rawValue,
            "screen": screen.rawValue
        ]
        if let item {
            params["item"] = item.rawValue
        }
        YMMYandexMetrica.reportEvent(name, parameters: params, onFailure: { (error) in
            print("DID FAIL REPORT EVENT: %@", name)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}


enum Event: String {
    case open = "open"
    case close = "close"
    case click = "click"
}

enum Screen: String {
    case main = "main"
}

enum Item: String {
    case addTrack = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}