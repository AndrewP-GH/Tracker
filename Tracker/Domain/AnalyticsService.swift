//
// Created by Андрей Парамонов on 25.11.2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    private static var isActivated = false

    static func activate() {
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "A3-LN993T-CXPGH6-MT734-XG9EV-VHPJ2-XK9L9")
        YMMYandexMetrica.activate(with: configuration!)
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
