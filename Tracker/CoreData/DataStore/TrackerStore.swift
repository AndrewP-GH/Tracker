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
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData()
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
        try? fetchedResultsController.performFetch()
        delegate?.reloadData()
    }

    func performFetch() {
        try? fetchedResultsController.performFetch()
    }
}
