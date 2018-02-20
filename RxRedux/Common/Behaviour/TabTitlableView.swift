import UIKit

protocol TabTitlableView {
    func setTabTitle(_ title: String)
}

extension TabTitlableView where Self: UIViewController {
    func setTabTitle(_ title: String) {
        navigationController?.tabBarItem.title = title
    }
}
