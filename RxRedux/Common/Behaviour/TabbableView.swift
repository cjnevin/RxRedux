import UIKit

protocol TabbableView {
    func setTabTitle(_ title: String)
}

extension TabbableView where Self: UIViewController {
    func setTabTitle(_ title: String) {
        navigationController?.tabBarItem.title = title
    }
}
