//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Андрей Парамонов on 22.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    var categories: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = [] // trackers for selected date
    var currentDate: Date = Date()
    var visibleCategories: [TrackerCategory] = createTrackers()

    private lazy var plusImageButton: UIButton = {
        let plusImage = UIButton()
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        plusImage.setImage(UIImage(named: "AddTracker"), for: .normal)
        plusImage.tintColor = .ypBlack
        plusImage.contentMode = .scaleAspectFit
        plusImage.backgroundColor = .clear
        plusImage.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        return plusImage
    }()

    private lazy var plusButton: UIBarButtonItem = {
        let plusButton = UIBarButtonItem(customView: plusImageButton)
        return plusButton
    }()

    private lazy var trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackerLabel.textColor = .ypBlack
        trackerLabel.textAlignment = .left
        trackerLabel.text = "Трекеры"
        return trackerLabel
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.backgroundColor = .ypBackground
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.init(identifier: "ru_RU")
        datePicker.date = currentDate
        return datePicker
    }()

    private lazy var datePickerButton: UIBarButtonItem = {
        let datePickerButton = UIBarButtonItem(customView: datePicker)
        return datePickerButton
    }()

    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 16))
        let imageView = UIImageView(frame: CGRect(x: 8, y: 0, width: 16, height: 16))
        imageView.image = UIImage(systemName: "magnifyingglass",
                                  withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?
                .withTintColor(.ypGray, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(imageView)
        searchTextField.leftViewMode = .always
        searchTextField.leftView = iconContainer
        searchTextField.placeholder = "Поиск"
        searchTextField.backgroundColor = .ypBackground
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        searchTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        searchTextField.textColor = .ypBlack
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.textAlignment = .left
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        searchTextField.delegate = self
        return searchTextField
    }()

    private lazy var trackersView: UICollectionView = {
        let trackersView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        trackersView.translatesAutoresizingMaskIntoConstraints = false
        trackersView.backgroundColor = .clear
        trackersView.register(TrackerCollectionViewCell.self,
                              forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        trackersView.dataSource = self
        trackersView.delegate = self
        trackersView.showsVerticalScrollIndicator = false
        trackersView.showsHorizontalScrollIndicator = false
        return trackersView
    }()

    private lazy var emptyTrackersPlaceholderView: EmptyTrackersPlaceholderView = {
        let emptyTrackersPlaceholderView = EmptyTrackersPlaceholderView()
        emptyTrackersPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        return emptyTrackersPlaceholderView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        addSubviews()
        setupConstraints()
    }

    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar,
              let topItem = navBar.topItem else {
            return
        }
        topItem.setLeftBarButton(plusButton, animated: false)
        topItem.setRightBarButton(datePickerButton, animated: false)
    }

    private func addSubviews() {
        view.addSubview(trackerLabel)
        view.addSubview(searchTextField)
        view.addSubview(trackersView)
        view.addSubview(emptyTrackersPlaceholderView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    plusImageButton.widthAnchor.constraint(equalToConstant: 42),
                    plusImageButton.heightAnchor.constraint(equalToConstant: 42),

                    trackerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
                    trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

                    searchTextField.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
                    searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    searchTextField.heightAnchor.constraint(equalToConstant: 36),

                    trackersView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
                    trackersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    trackersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    trackersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                    emptyTrackersPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    emptyTrackersPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ]
        )
    }

    @objc
    private func addTracker() {
        let addTrackerViewController = AddTrackerViewController()
        present(addTrackerViewController, animated: true)
    }

    @objc
    private func dateChanged() {
        currentDate = datePicker.date
        // TODO: в результате показываются только те трекеры, у которых в расписании выбран день, совпадающий с датой в currentDate;
    }

    @objc
    private func searchTextChanged() {
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier,
                                                      for: indexPath) as! TrackerCollectionViewCell
        let tracker = visibleCategories[indexPath.section].items[indexPath.row]
        cell.configure(with: tracker)
        return cell
    }

}

extension TrackersViewController: UICollectionViewDelegate {
}


extension TrackersViewController {
    class func createTrackers() -> [TrackerCategory] {
        [
            TrackerCategory(header: "Домашний уют", items: [
                Tracker(id: UUID(),
                        name: "Поливать растения",
                        color: .green,
                        emoji: "❤️",
                        schedule: nil)]
            ),
            TrackerCategory(header: "Радостные мелочи", items: [
                Tracker(id: UUID(),
                        name: "Кошка заслонила камеру на созвоне",
                        color: .orange,
                        emoji: "😻",
                        schedule: nil),
                Tracker(id: UUID(),
                        name: "Бабушка прислала открытку в вотсапе",
                        color: .red,
                        emoji: "🌺",
                        schedule: nil),
                Tracker(id: UUID(),
                        name: "Свидания в апреле",
                        color: .blue,
                        emoji: "❤️",
                        schedule: nil)]
            ),
            TrackerCategory(header: "Самочувствие", items: [
                Tracker(id: UUID(),
                        name: "Хорошее настроение",
                        color: .purple,
                        emoji: "🙂",
                        schedule: nil),
                Tracker(id: UUID(),
                        name: "Легкая тревожность",
                        color: .ypBlue,
                        emoji: "😪",
                        schedule: nil)]
            )
        ]
    }
}