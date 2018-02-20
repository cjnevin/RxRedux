import UIKit

private extension StyleViewController {
    typealias Presenter = StylePresenter<StyleViewController>
    
    static var `defaultPresenter`: Presenter {
        let presenter = Presenter()
        presenter.attachPresenters([
            LocalizableTitlePresenter(localizationKey: "style.title"),
            LocalizableTabTitlePresenter(localizationKey: "style.tab.title")
            ])
        return presenter
    }
    
    static func make(presenter: Presenter = defaultPresenter) -> UIViewController {
        let viewController = StyleViewController()
        viewController.presenter = presenter
        return viewController
    }
}

class StyleNavigationController: UINavigationController {
    override init(rootViewController: UIViewController = StyleViewController.make()) {
        super.init(rootViewController: rootViewController)
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "theme-empty"), selectedImage: #imageLiteral(resourceName: "theme-filled"))
        tabBarItem.accessibilityLabel = "Style Tab"
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


