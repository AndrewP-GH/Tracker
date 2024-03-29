//
// Created by Андрей Парамонов on 29.09.2023.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackerCollectionViewCell"
    var previewView: UIView? {
        coloredView
    }

    private var tracker: Tracker?
    private weak var delegate: TrackersViewDelegate?
    private var analyticsService: AnalyticsService?

    private var completedDays = 0 {
        didSet {
            setDaysLabel()
        }
    }

    private var isDone = false {
        didSet {
            setButtonImage()
        }
    }

    private var canBeDone = false {
        didSet {
            setButtonEnabled()
        }
    }

    private lazy var coloredView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(r: 174, g: 175, b: 180, alpha: 0.3).cgColor
        return view
    }()

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor.init(white: 1.0, alpha: 0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()

    private lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Pin")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()

    private lazy var controlView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .clear
        label.textColor = .ypBlack
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "PlusButton"), for: .normal)
        button.backgroundColor = .ypWhite
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        return button
    }()

    private lazy var buttonOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite.withAlphaComponent(0.63) // 1 - 0.37 from svg background
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with model: CellModel, delegate: TrackersViewDelegate, analyticsService: AnalyticsService?) {
        tracker = model.tracker
        self.delegate = delegate
        completedDays = model.completedDays
        isDone = model.isDone
        canBeDone = model.canBeDone
        self.analyticsService = analyticsService
        updateContentView()
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(coloredView)
        coloredView.addSubview(emojiLabel)
        coloredView.addSubview(pinImageView)
        coloredView.addSubview(textStackView)
        textStackView.addSubview(nameLabel)
        contentView.addSubview(controlView)
        controlView.addSubview(daysLabel)
        controlView.addSubview(button)
        button.addSubview(buttonOverlay)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    coloredView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
                    coloredView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
                    coloredView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
                    coloredView.heightAnchor.constraint(equalToConstant: 90),

                    emojiLabel.topAnchor.constraint(equalTo: coloredView.topAnchor, constant: 12),
                    emojiLabel.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 12),
                    emojiLabel.widthAnchor.constraint(equalToConstant: 24),
                    emojiLabel.heightAnchor.constraint(equalToConstant: 24),

                    pinImageView.topAnchor.constraint(equalTo: coloredView.topAnchor, constant: 12),
                    pinImageView.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor, constant: -4),
                    pinImageView.widthAnchor.constraint(equalToConstant: 24),
                    pinImageView.heightAnchor.constraint(equalToConstant: 24),

                    textStackView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
                    textStackView.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 12),
                    textStackView.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor, constant: -12),
                    textStackView.bottomAnchor.constraint(equalTo: coloredView.bottomAnchor, constant: -12),

                    nameLabel.topAnchor.constraint(greaterThanOrEqualTo: textStackView.topAnchor),
                    nameLabel.leadingAnchor.constraint(equalTo: textStackView.leadingAnchor),
                    nameLabel.trailingAnchor.constraint(equalTo: textStackView.trailingAnchor),
                    nameLabel.bottomAnchor.constraint(equalTo: textStackView.bottomAnchor),

                    controlView.topAnchor.constraint(equalTo: coloredView.bottomAnchor),
                    controlView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
                    controlView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
                    controlView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

                    daysLabel.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 16),
                    daysLabel.leadingAnchor.constraint(equalTo: controlView.leadingAnchor, constant: 12),
                    daysLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),

                    button.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 8),
                    button.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -12),
                    button.widthAnchor.constraint(equalToConstant: 34),
                    button.heightAnchor.constraint(equalToConstant: 34),

                    buttonOverlay.topAnchor.constraint(equalTo: button.topAnchor),
                    buttonOverlay.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                    buttonOverlay.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                    buttonOverlay.bottomAnchor.constraint(equalTo: button.bottomAnchor)
                ]
        )
    }

    private func updateContentView() {
        guard let tracker else {
            return
        }
        coloredView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        button.tintColor = tracker.color
        pinImageView.isHidden = !tracker.isPinned

        setDaysLabel()
        setButtonImage()
        setButtonEnabled()
    }

    @objc private func buttonTapped() {
        analyticsService?.report(name: "buttonTapped", event: .click, screen: .main, item: .track)
        isDone.toggle()
        if let tracker, let delegate {
            if isDone {
                delegate.didCompleteTracker(id: tracker.id)
            } else {
                delegate.didUncompleteTracker(id: tracker.id)
            }
        }
    }

    private func setButtonImage() {
        if isDone {
            button.setImage(UIImage(named: "DoneButton"), for: .normal)
        } else {
            button.setImage(UIImage(named: "PlusButton"), for: .normal)
        }
    }

    private func setDaysLabel() {
        daysLabel.text = L10n.Localizable.numberOfDays(completedDays)
    }

    private func setButtonEnabled() {
        buttonOverlay.isHidden = canBeDone
    }
}
