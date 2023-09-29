//
// Created by Андрей Парамонов on 29.09.2023.
//

import Foundation
import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackerCollectionViewCell"

    var tracker: Tracker?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with tracker: Tracker) {
        self.tracker = tracker
        updateContent()
    }

    private func setupView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                ]
        )
    }

    private func updateContent() {
        guard let tracker else {
            return
        }
        contentView.backgroundColor = tracker.color
    }
}
