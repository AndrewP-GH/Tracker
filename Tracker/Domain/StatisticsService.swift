//
// Created by Андрей Парамонов on 29.11.2023.
//

import Foundation

protocol StatisticsServiceProtocol {
    func getStatistics() -> Statistics
}

final class StatisticsService: StatisticsServiceProtocol {
    private let recordsStore: TrackerRecordStoreProtocol
    private let trackersStore: TrackersStoreProtocol

    init(recordsStore: TrackerRecordStoreProtocol, trackersStore: TrackersStoreProtocol) {
        self.recordsStore = recordsStore
        self.trackersStore = trackersStore

    }

    func getStatistics() -> Statistics {
        let records = getRecords()
        let recordsPerDay = Dictionary(grouping: records, by: { $0.date })
        let bestPeriod = bestPeriod(recordsPerDay: recordsPerDay)
        let idealDays = aggregateByDate(recordsPerDay: recordsPerDay)
        let daysCount = recordsPerDay.count
        let averagePerDay = daysCount > 0
                ? Int(round(recordsPerDay.map { Double($0.value.count) }.reduce(0, +) / Double(daysCount)))
                : 0
        let finished = records.count
        return Statistics(bestPeriod: bestPeriod,
                          idealDays: idealDays,
                          trackersFinished: finished,
                          averagePerDay: averagePerDay)
    }

    private func getRecords() -> [TrackerRecord] {
        do {
            return try recordsStore.getAll()
        } catch {
            return []
        }
    }

    func bestPeriod(recordsPerDay: [DateOnly: [TrackerRecord]]) -> Int {
        var bestPeriod = recordsPerDay.count > 0 ? 1 : 0
        let dates = recordsPerDay.keys.sorted(by: { $0 < $1 })
        var i = 1
        var period = 1
        while i < dates.count {
            let date = dates[i]
            let prevDate = dates[i - 1]
            if prevDate.addingDays(1) == date {
                period += 1
            } else {
                period = 1
            }
            if period > bestPeriod {
                bestPeriod = period
            }
            i += 1
        }
        return bestPeriod
    }

    func aggregateByDate(recordsPerDay: [DateOnly: [TrackerRecord]]) -> Int {
        var idealDays = 0
        for (date, records) in recordsPerDay {
            do {
                let trackersCount = try trackersStore.countBy(dateOnly: date)
                if trackersCount == records.count {
                    idealDays += 1
                }
            } catch {
                continue
            }
        }
        return idealDays
    }

}
