//
// Created by Андрей Парамонов on 20.08.2023.
//

import UIKit

final class EmptyResultPlaceholderView: UIView {
    private let emptyStateText: String
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    init(emptyStateText: String) {
        self.emptyStateText = emptyStateText
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
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
            titleLabel.text = emptyStateText
            imageView.image = UIImage(named: "EmptyTrackers")
        case .noResults:
            titleLabel.text = "Ничего не найдено"
            imageView.image = UIImage(named: "NoResults")
        case .noStatistics:
            titleLabel.text = "Анализировать пока нечего"
            imageView.image = UIImage(named: "NoAnalyze")
        }
    }

}
