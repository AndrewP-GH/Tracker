//
// Created by Андрей Парамонов on 05.10.2023.
//

import Foundation
import UIKit

protocol CellWithValueProtocol: UICollectionViewCell {
    associatedtype TValue
    static var identifier: String { get }
    var value: TValue { get set }
}
