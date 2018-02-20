import UIKit

private extension CountViewController {
    typealias Presenter = CountPresenter<CountViewController>
    
    static var `defaultPresenter`: Presenter {
        let countPresenter = Presenter()
        countPresenter.attachPresenters([
            LocalizableTitlePresenter(localizationKey: "count.title"),
            LocalizableTabTitlePresenter(localizationKey: "count.tab.title")
        ])
        return countPresenter
    }
    
    static func make(presenter: Presenter = defaultPresenter) -> UIViewController {
        let countViewController = CountViewController()
        countViewController.presenter = presenter
        return countViewController
    }
}

class CountNavigationController: UINavigationController {
    override init(rootViewController: UIViewController = CountViewController.make()) {
        super.init(rootViewController: rootViewController)
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "counter-empty"), selectedImage: #imageLiteral(resourceName: "counter-filled"))
        tabBarItem.accessibilityLabel = "Count Tab"
        _ = rootViewController.view
    }
    
    // Must be overridden or we get:
    // Fatal error: Use of unimplemented initializer 'init(nibName:bundle:)' for class
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
