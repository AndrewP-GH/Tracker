//
// Created by Андрей Парамонов on 13.10.2023.
//

import Foundation
import UIKit

final class DynamicCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        contentSize
    }
}
