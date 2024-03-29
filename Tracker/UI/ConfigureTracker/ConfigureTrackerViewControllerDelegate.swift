//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation

protocol ConfigureTrackerViewControllerDelegate: AnyObject {
    func setSchedule(schedule: [WeekDay])
    func setCategory(category: TrackerCategory?)
}
