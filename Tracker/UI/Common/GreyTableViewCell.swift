//
// Created by Андрей Парамонов on 28.09.2023.
//

import UIKit

class GreyTableViewCell: UITableViewCell {
    var isLast: Bool = false {
        didSet {
            separatorView.isHidden = isLast
        }
    }

    private lazy var separatorView: UIView = {
        let rowSeparator = UIView()
        rowSeparator.translatesAutoresizingMaskIntoConstraints = false
        rowSeparator.backgroundColor = .ypGray
        return rowSeparator
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .ypBackground
        selectionStyle = .none
        isUserInteractionEnabled = true
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(separatorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0.5),
                    separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    separatorView.heightAnchor.constraint(equalToConstant: 0.5),
                ]
        )
    }
}