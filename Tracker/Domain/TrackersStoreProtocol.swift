//
// Created by Андрей Парамонов on 24.10.2023.
//

import Foundation

protocol TrackersStoreProtocol {
    func filter(prefix: String?, weekDay: WeekDay)
    func performFetch()

    var delegate: TrackersViewDelegate? { get set }
}
