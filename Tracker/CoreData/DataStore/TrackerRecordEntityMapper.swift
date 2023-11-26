//
// Created by Андрей Парамонов on 26.11.2023.
//

import Foundation
import CoreData

struct TrackerRecordEntityMapper {
    private let dateMarshalling = DateMarshalling()

    func map(from record: TrackerRecord, context: NSManagedObjectContext) -> TrackerRecordEntity {
        let recordEntity = TrackerRecordEntity(context: context)
        recordEntity.trackerId = record.trackerId
        recordEntity.date = dateMarshalling.toString(from: record.date)
        return recordEntity
    }

    func map(from recordEntity: TrackerRecordEntity) throws -> TrackerRecord {
        guard let trackerId = recordEntity.trackerId,
              let date = recordEntity.date,
              let date = dateMarshalling.toDate(from: date) else { throw StoreError.decodeError }
        return TrackerRecord(trackerId: trackerId, date: date)
    }

    func map(from date: Date) -> String {
        dateMarshalling.toString(from: date)
    }
}
