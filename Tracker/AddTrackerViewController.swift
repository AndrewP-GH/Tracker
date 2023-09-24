//
// Created by Андрей Парамонов on 24.09.2023.
//

import Foundation
import UIKit

class AddTrackerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        title = "Создание теркера"
    }
}