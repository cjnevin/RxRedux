import UIKit

protocol TitlableView {
    func setTitle(_ title: String)
}

extension TitlableView where Self: UIViewController {
    func setTitle(_ title: String) {
        navigationItem.title = title
    }
}
