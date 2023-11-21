//
// Created by Андрей Парамонов on 10.10.2023.
//

import Foundation
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
        let noSchedulePredicate = NSPredicate(format: "%K == nil", #keyPath(TrackerEntity.schedule))
        let byDayPredicate = NSPredicate(format: "%K CONTAINS %@",
                                         #keyPath(TrackerEntity.schedule),
                                         mapper.map(from: weekDay))
        var predicates: [NSPredicate] = [
            NSCompoundPredicate(orPredicateWithSubpredicates: [noSchedulePredicate, byDayPredicate])
        ]
        if let prefix, !prefix.isEmpty {
            predicates.append(NSPredicate(format: "%K BEGINSWITH[c] %@", #keyPath(TrackerEntity.name), prefix))
        }
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchedResultsController.fetchRequest.predicate = predicate
        performFetch()
        sendResult()
    }

    func performFetch() {
        try? fetchedResultsController.performFetch()
    }

    func update(tracker: Tracker) throws {
        guard let entity = fetchedResultsController.fetchedObjects?
                .first(where: { $0.id == tracker.id }) else { return }
        try mapper.map(from: tracker, to: entity)
        try context.save()
        performFetch()
        sendResult()
    }

    func category(for tracker: Tracker) throws -> TrackerCategory? {
        guard let entity = fetchedResultsController.fetchedObjects?
                .first(where: { $0.id == tracker.id }) else { return nil }
        guard let category = entity.category else { return nil }
        guard let id = category.id,
              let header = category.header else { throw StoreError.decodeError }
        return TrackerCategory(id: id, header: header)
    }

    private func sendResult() {
        guard let delegate, let fetched = fetchedResultsController.fetchedObjects else { return }
        let trackers = Dictionary(grouping: fetched, by: { $0.category?.header ?? "" })
                .mapValues({ $0.compactMap({ try? mapper.map(from: $0) }) })
        delegate.fetchedObjects(trackersByCategory: trackers)
    }
}
