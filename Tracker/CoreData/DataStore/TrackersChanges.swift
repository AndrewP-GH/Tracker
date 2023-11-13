//
// Created by Андрей Парамонов on 24.10.2023.
//

import Foundation

struct TrackersChanges {
    var insertions: [IndexPath] = []
    var deletions: [IndexPath] = []
    var updates: [IndexPath] = []
    var moves: [(from: IndexPath, to: IndexPath)] = []

    mutating func reset() {
        insertions.removeAll()
        deletions.removeAll()
        updates.removeAll()
        moves.removeAll()
    }
}
