//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController {
    private let cellHeight: CGFloat = 75
    private let cornerRadius: CGFloat = 16
    private var viewModel: CategoryViewModelProtocol

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        return label
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = cornerRadius
        scrollView.layer.masksToBounds = true
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
    }()

    private lazy var configureTable: UITableView = {
        let configureTable = UITableView()
        configureTable.translatesAutoresizingMaskIntoConstraints = false
        configureTable.backgroundColor = .ypBackground
        configureTable.separatorStyle = .none
        configureTable.showsVerticalScrollIndicator = false
        configureTable.showsHorizontalScrollIndicator = false
        configureTable.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        configureTable.delegate = self
        configureTable.dataSource = self
        configureTable.layer.cornerRadius = cornerRadius
        configureTable.layer.masksToBounds = true
        configureTable.isScrollEnabled = false
        return configureTable
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
        return button
    }()

    init(viewModel: CategoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.categoryChangedDelegate = { [weak self] in
            self?.configureTable.reloadData()
        }
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(configureTable)
        view.addSubview(button)
    }

    private func setupConstraints() {
        let sideInset: CGFloat = 16
        let safeG = view.safeAreaLayoutGuide
        let svContentG = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate(
                [
                    scrollView.topAnchor.constraint(equalTo: safeG.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: sideInset),
                    scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -sideInset),
                    scrollView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16),

                    svContentG.bottomAnchor.constraint(equalTo: configureTable.bottomAnchor),

                    contentView.topAnchor.constraint(equalTo: svContentG.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

                    titleLabel.topAnchor.constraint(equalTo: svContentG.topAnchor, constant: 26),
                    titleLabel.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor),
                    titleLabel.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor),

                    configureTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
                    configureTable.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor),
                    configureTable.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor),
                    configureTable.heightAnchor.constraint(equalToConstant: cellHeight * 7),

                    button.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -16),
                    button.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 20),
                    button.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -20),
                    button.heightAnchor.constraint(equalToConstant: 60),
                ]
        )
    }

    @objc private func applyTapped() {
        defer {
            dismiss(animated: true)
        }
        viewModel.applyTapped()
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier,
                                                 for: indexPath) as! CategoryTableViewCell
        cell.configure(model: viewModel.category(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CategoryTableViewCell {
            cell.isLast = tableView.isLastCellInSection(at: indexPath)
        }
    }
}
