import UIKit

private extension LanguageViewController {
    typealias Presenter = LanguagePresenter<LanguageViewController>
    
    static var `defaultPresenter`: Presenter {
        let presenter = Presenter()
        presenter.attachPresenters([
            LocalizableTitlePresenter(localizationKey: "language.title"),
            LocalizableTabTitlePresenter(localizationKey: "language.tab.title")
        ])
        return presenter
    }
    
    static func make(presenter: Presenter = defaultPresenter) -> UIViewController {
        let viewController = LanguageViewController()
        viewController.presenter = presenter
        return viewController
    }
}

class LanguageNavigationController: UINavigationController {
    override init(rootViewController: UIViewController = LanguageViewController.make()) {
        super.init(rootViewController: rootViewController)
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "language-empty"), selectedImage: #imageLiteral(resourceName: "language-filled"))
        tabBarItem.accessibilityLabel = "Language Tab"
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

