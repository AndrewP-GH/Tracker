//
// Created by Андрей Парамонов on 26.09.2023.
//

import Foundation
import UIKit

final class TrackerCustomizationViewCell: UICollectionViewCell {
    static let identifier = "TrackerCustomizationViewCell"

    enum CustomizationCellValue {
        case none
        case color(UIColor)
        case emoji(String)
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()

    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()

    private func setTitle(_ title: String?) {
        titleLabel.text = title
    }

    var value: CustomizationCellValue = .none {
        didSet {
            switch value {
            case .none:
                setColor(nil)
                setTitle(nil)
            case .color(let color):
                setColor(color)
            case .emoji(let title):
                setTitle(title)
            }
        }
    }

    private func setColor(_ color: UIColor?) {
        colorView.backgroundColor = color
    }

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
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(colorView)
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(getContentConstraints(colorView) + getContentConstraints(titleLabel))
    }

    private func getContentConstraints(_ view: UIView) -> [NSLayoutConstraint] {
        [
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
    }
}


