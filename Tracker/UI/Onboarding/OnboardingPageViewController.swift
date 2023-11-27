//
// Created by Андрей Парамонов on 14.11.2023.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textColor = .ypBlack
        return label
    }()

    init(title: String, imageName: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        imageView.image = UIImage(named: imageName)
    }

    required init?(coder: NSCoder) {
        print("init(coder:) has not been implemented")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate(
                [
                    imageView.topAnchor.constraint(equalTo: view.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                    titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 64),
                    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
                ]
        )
    }
}
