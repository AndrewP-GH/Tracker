//
// Created by Андрей Парамонов on 10.10.2023.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private let mapper = TrackerEntityMapper()

    weak var delegate: TrackersViewDelegate?

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerEntity> = {
        let fetchRequest = TrackerEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerEntity.category!.header, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController<TrackerEntity>(fetchRequest: fetchRequest,
                                                                                 managedObjectContext: context,
                                                                                 sectionNameKeyPath: "category.header",
                                                                                 cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("appDelegate is nil")
        }
        context = appDelegate.persistentContainer.viewContext
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sendResult()
    }
}

extension TrackerStore: TrackersStoreProtocol {
    func filter(prefix: String?, weekDay: WeekDay) {
        var predicates = [withoutScheduleOrByWeekDayPredicate(weekDay)]
        if let prefix, !prefix.isEmpty {
            predicates.append(NSPredicate(format: "%K BEGINSWITH[c] %@", #keyPath(TrackerEntity.name), prefix))
        }
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchedResultsController.fetchRequest.predicate = compoundPredicate
        performFetch()
        sendResult()
    }

    func performFetch() {
        try? fetchedResultsController.performFetch()
    }

    func update(tracker: Tracker) throws {
        let entity = try getById(id: tracker.id)
        try mapper.map(from: tracker, to: entity)
        try context.save()
    }

    func category(for tracker: Tracker) throws -> TrackerCategory {
        let entity = try getById(id: tracker.id)
        guard let category = entity.category else { throw StoreError.notFound }
        guard let id = category.id,
              let header = category.header else { throw StoreError.decodeError }
        return TrackerCategory(id: id, header: header)
    }

    private func getById(id: UUID) throws -> TrackerEntity {
        if let entity = fetchedResultsController.fetchedObjects?.first(where: { $0.id == id }) {
            return entity
        }
        throw StoreError.notFound
    }

    private func sendResult() {
        guard let delegate, let fetched = fetchedResultsController.fetchedObjects else { return }
        let trackers = Dictionary(grouping: fetched, by: { $0.category?.header ?? "" })
                .mapValues({ $0.compactMap({ try? mapper.map(from: $0) }) })
        delegate.fetchedObjects(trackersByCategory: trackers)
    }

    func delete(tracker: Tracker) throws {
        guard let entity = fetchedResultsController.fetchedObjects?
                                                   .first(where: { $0.id == tracker.id }) else { return }
        context.delete(entity)
        try context.save()
    }

    private func withoutScheduleOrByWeekDayPredicate(_ weekDay: WeekDay) -> NSPredicate {
        let noSchedulePredicate = NSPredicate(format: "%K == nil", #keyPath(TrackerEntity.schedule))
        let byDayPredicate = NSPredicate(format: "%K CONTAINS %@",
                                         #keyPath(TrackerEntity.schedule),
                                         mapper.map(from: weekDay))
        return NSCompoundPredicate(orPredicateWithSubpredicates: [noSchedulePredicate, byDayPredicate])
    }

    func countBy(dateOnly: DateOnly) throws -> Int {
        guard let weekDay = dateOnly.dayOfWeek else { throw StoreError.encodeError }
        let schedulePredicate = withoutScheduleOrByWeekDayPredicate(weekDay)
//        I think we should filter by 'createdAt' property, but if we show this trackers in the list, let's count them
//        let createdAtPredicate = NSPredicate(format: "%K <= %@", #keyPath(TrackerEntity.createdAt), dateOnly.date as NSDate)
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [schedulePredicate, createdAtPredicate])
        let fetchRequest = TrackerEntity.fetchRequest()
        fetchRequest.predicate = schedulePredicate
        return try context.count(for: fetchRequest)
    }
}
