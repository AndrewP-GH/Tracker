//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation
import UIKit

final class CategoriesViewController: UIViewController {
    private let cellHeight: CGFloat = 75
    private let cornerRadius: CGFloat = 16
    private var viewModel: CategoriesViewModelProtocol
    private var tableHeightConstraint: NSLayoutConstraint?

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
        configureTable.register(CategoriesTableViewCell.self,
                                forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        configureTable.delegate = self
        configureTable.dataSource = self
        configureTable.layer.cornerRadius = cornerRadius
        configureTable.layer.masksToBounds = true
        configureTable.isScrollEnabled = false
        configureTable.rowHeight = cellHeight
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
        button.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        return button
    }()

    private lazy var emptyTrackersPlaceholderView: EmptyTrackersPlaceholderView = {
        let emptyTrackersPlaceholderView = EmptyTrackersPlaceholderView(
                emptyStateText: """
                                Привычки и события можно
                                объединить по смыслу
                                """
        )
        emptyTrackersPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        return emptyTrackersPlaceholderView
    }()

    init(viewModel: CategoriesViewModelProtocol) {
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
        viewModel.placeholderStateObservable.bind { [weak self] state in
            self?.placeholderDidChange(state: state)
        }
        viewModel.reloadDataDelegate = { [weak self] in
            self?.configureTable.reloadData()
        }
        setupView()
        viewModel.viewDidLoad()
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
        contentView.addSubview(emptyTrackersPlaceholderView)
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

                    emptyTrackersPlaceholderView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                    emptyTrackersPlaceholderView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
                    emptyTrackersPlaceholderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                                          constant: 16),
                    emptyTrackersPlaceholderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                                           constant: -16),

                    button.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -16),
                    button.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 20),
                    button.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -20),
                    button.heightAnchor.constraint(equalToConstant: 60),
                ]
        )
    }

    @objc private func createCategory() {
        let vc = CreateCategoryViewController()
        vc.delegate = self
        present(vc, animated: true)
    }

    private func placeholderDidChange(state: PlaceholderState) {
        switch state {
        case .hide:
            configureTable.isHidden = false
            emptyTrackersPlaceholderView.isHidden = true
        default:
            emptyTrackersPlaceholderView.configure(state: state)
            configureTable.isHidden = true
            emptyTrackersPlaceholderView.isHidden = false
        }
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = viewModel.numberOfItems()
        tableHeightConstraint?.isActive = false
        let newHeightConstraint = configureTable.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(rows))
        newHeightConstraint.isActive = true
        tableHeightConstraint = newHeightConstraint
        return rows
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.identifier,
                                                 for: indexPath) as? CategoriesTableViewCell
                ?? CategoriesTableViewCell()
        cell.configure(model: viewModel.category(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CategoriesTableViewCell {
            cell.isLast = tableView.isLastCellInSection(at: indexPath)
        }
    }
}

extension CategoriesViewController: AddCategoryViewControllerDelegate {
    func addCategory(category: TrackerCategory) {
        viewModel.addCategory(category: category)
    }
}
