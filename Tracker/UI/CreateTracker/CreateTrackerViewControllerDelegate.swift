//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func setSchedule(schedule: [WeekDay])
}
