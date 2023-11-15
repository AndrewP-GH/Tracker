//
// Created by Андрей Парамонов on 12.08.2023.
//

import Foundation
import UIKit

final class HomePageViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        setupTabBar()
        viewControllers = getViewControllers()
        selectedIndex = 0
    }

    private func setupTabBar() {
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypGray
        let borderView = getTopBorderView()
        tabBar.addSubview(borderView)
    }

    private func getTopBorderView() -> UIView {
        let topBorderView = UIView()
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = .ypGray
        topBorderView.frame = CGRect(x: 0, y: 0.5, width: view.frame.width, height: 0.5)
        return topBorderView
    }

    private func getViewControllers() -> [UIViewController] {
        let trackersViewController = TrackersViewController()
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        navigationController.tabBarItem = UITabBarItem(title: "Трекеры",
                                                         image: UIImage(named: "Trackers"),
                                                         selectedImage: nil)
        let settingsViewController = StatisticsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                                         image: UIImage(named: "Statistics"),
                                                         selectedImage: nil)
        return [navigationController, settingsViewController]
    }
}