import UIKit

protocol Searchable {
    func dismissSearch()
}

class TabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        let imageSearch = ImageSearchNavigationController()
        router.add(router: imageSearch)
        
        viewControllers = [
            imageSearch,
            CountNavigationController(),
            StyleNavigationController(),
            LanguageNavigationController()]
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let navigationController = viewControllers?[selectedIndex] as? UINavigationController {
            for myController in navigationController.viewControllers.flatMap({ $0 as? Searchable }) {
                myController.dismissSearch()
            }
        }
        return true
    }
}
