//
// Created by Андрей Парамонов on 13.11.2023.
//

import Foundation

final class OnboardingDataStore {
    private let userDefaults = UserDefaults.standard
    private let onboardingWasShownKey = "onboardingWasShown"

    static let shared = OnboardingDataStore()

    private init() {}

    func isOnboardingWasShown() -> Bool {
        userDefaults.bool(forKey: onboardingWasShownKey)
    }

    func setOnboardingWasShown() {
        userDefaults.set(true, forKey: onboardingWasShownKey)
    }
}
