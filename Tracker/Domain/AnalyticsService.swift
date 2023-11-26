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

    func report(event: String, params: [AnyHashable: Any]) {
        if !AnalyticsService.isActivated { return }
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { (error) in
            print("DID FAIL REPORT EVENT: %@", event)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
