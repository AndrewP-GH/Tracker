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
            NSSortDescriptor(keyPath: \TrackerEntity.category!.header, ascending: true),
            NSSortDescriptor(keyPath: \TrackerEntity.name, ascending: true)
        ]
        let fetchedResultsController = NSFetchedResultsController<TrackerEntity>(fetchRequest: fetchRequest,
                                                                                 managedObjectContext: context,
                                                                                 sectionNameKeyPath: "category.header",
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
        switch type {
        case .insert:
            guard let newIndexPath else { fatalError("newIndexPath is nil") }
            changes.insertions.append(newIndexPath)
        case .delete:
            guard let indexPath else { fatalError("indexPath is nil") }
            changes.deletions.append(indexPath)
        case .update:
            guard let indexPath else { fatalError("indexPath is nil") }
            changes.updates.append(indexPath)
        case .move:
            guard let indexPath else { fatalError("indexPath is nil") }
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

    func tracker(at indexPath: IndexPath) throws -> Tracker {
        let trackerEntity = fetchedResultsController.object(at: indexPath)
        return try mapper.map(from: trackerEntity)
    }

    func filter(prefix: String?, weekDay: WeekDay) {
        let noSchedulePredicate = NSPredicate(format: "%K == nil", #keyPath(TrackerEntity.schedule))
        var byArgPredicates = [
            NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerEntity.schedule), mapper.map(from: weekDay))
        ]
        if let prefix, !prefix.isEmpty {
            byArgPredicates.append(NSPredicate(format: "%K BEGINSWITH[c] %@", #keyPath(TrackerEntity.name), prefix))
        }
        let byArgsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: byArgPredicates)
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [noSchedulePredicate, byArgsPredicate])
        fetchedResultsController.fetchRequest.predicate = predicate
        try? fetchedResultsController.performFetch()
        delegate?.reloadData()
    }

    func performFetch() {
        try? fetchedResultsController.performFetch()
    }
}
