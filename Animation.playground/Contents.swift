import Foundation
import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 700))

let t1 = CGAffineTransform(rotationAngle: 3.14)

UIView.animateKeyframes(withDuration: 5, delay: 0) {
    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
        view.backgroundColor = .red
        view.transform = t1
    }
    
    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
        view.backgroundColor = .yellow
    }
    
    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
        view.transform = view.transform.rotated(by: -1 * 3.14)
        view.backgroundColor = .green
    }
}


PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = view
