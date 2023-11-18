//
// Created by Андрей Парамонов on 20.08.2023.
//

import Foundation
import UIKit

final class EmptyTrackersPlaceholderView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        addSubview(imageView)
        addSubview(titleLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    imageView.topAnchor.constraint(equalTo: topAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: 80),
                    imageView.heightAnchor.constraint(equalToConstant: 80),

                    titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                    titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                ]
        )
    }

    func configure(state: PlaceholderState) {
        switch state {
        case .hide:
            titleLabel.text = ""
            imageView.image = nil
        case .empty:
            titleLabel.text = "Что будем отслеживать?"
            imageView.image = UIImage(named: "EmptyTrackers")
        case .noResults:
            titleLabel.text = "Ничего не найдено"
            imageView.image = UIImage(named: "NoResults")
        }
    }

}
