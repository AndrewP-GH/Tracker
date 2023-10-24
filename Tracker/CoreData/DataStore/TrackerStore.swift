//
// Created by Андрей Парамонов on 10.10.2023.
//

import Foundation
import UIKit
import CoreData

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private let mapper = TrackerEntityMapper()

    private var changes = TrackersChanges()

    weak var delegate: TrackersViewControllerDelegate?

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerEntity> = {
        let fetchRequest = TrackerEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerEntity.name, ascending: true),
            NSSortDescriptor(keyPath: \TrackerEntity.createdAt, ascending: true)
        ]
        let fetchedResultsController = NSFetchedResultsController<TrackerEntity>(fetchRequest: fetchRequest,
                                                                                 managedObjectContext: context,
                                                                                 sectionNameKeyPath: "category?.header",
                                                                                 cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
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

    func add(_ tracker: Tracker) throws {
        _ = mapper.map(from: tracker, context: context)
        try context.save()
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        changes.reset()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateTrackers(changes: changes)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let indexPath else { fatalError("indexPath is nil") }
        switch type {
        case .insert:
            changes.insertions.append(indexPath)
        case .delete:
            changes.deletions.append(indexPath)
        case .update:
            changes.updates.append(indexPath)
        case .move:
            guard let newIndexPath else { fatalError("newIndexPath is nil") }
            changes.moves.append((from: indexPath, to: newIndexPath))
        @unknown default:
            fatalError("unknown NSFetchedResultsChangeType")
        }
    }
}

extension TrackerStore: TrackersStoreProtocol {
    func categoriesCount() -> Int {
        fetchedResultsController.sections?.count ?? 0
    }

    func trackersCount(for category: Int) -> Int {
        fetchedResultsController.sections?[category].numberOfObjects ?? 0
    }

    func categoryName(at index: Int) -> String {
        guard let section = fetchedResultsController.sections?[index] else { fatalError("section is nil") }
        return section.name
    }

    func tracker(at indexPath: IndexPath) -> Tracker {
        let trackerEntity = fetchedResultsController.object(at: indexPath)
        return mapper.map(from: trackerEntity)
    }

    func filter(prefix: String?, weekDay: WeekDay) {
        let fetchRequest = TrackerEntity.fetchRequest() as NSFetchRequest<TrackerEntity>
        fetchRequest.predicate = NSPredicate(format: "name BEGINSWITH[c] %@ AND schedule.weekDay == %d",
                                             prefix ?? "",
                                             mapper.map(from: weekDay))
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerEntity.name, ascending: true),
            NSSortDescriptor(keyPath: \TrackerEntity.createdAt, ascending: true)
        ]
        let trackers = try? context.fetch(fetchRequest)
        return trackers?.compactMap { mapper.map(from: $0) } ?? []
    }
}
