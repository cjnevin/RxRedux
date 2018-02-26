import UIKit

protocol TabIcon {
    var image: UIImage { get }
    var selectedImage: UIImage { get }
}

protocol TabIconSettableView {
    func setTabIcon(_ tabIcon: TabIcon)
}

extension TabIconSettableView where Self: UIViewController {
    func setTabIcon(_ tabIcon: TabIcon) {
        navigationController?.tabBarItem.image = tabIcon.image
        navigationController?.tabBarItem.selectedImage = tabIcon.selectedImage
    }
}
