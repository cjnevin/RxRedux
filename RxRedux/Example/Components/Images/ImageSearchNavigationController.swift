import UIKit

private extension ImageSearchViewController {
    typealias Presenter = ImageSearchPresenter<ImageSearchViewController>
    
    static var defaultPresenter: Presenter {
        let imageSearchPresenter = Presenter()
        imageSearchPresenter.attachPresenters([
            LocalizableTitlePresenter(localizationKey: "image.search.title"),
            LocalizableTabTitlePresenter(localizationKey: "image.search.tab.title")
        ])
        return imageSearchPresenter
    }
    
    static func make(presenter: Presenter = defaultPresenter) -> ImageSearchViewController {
        let imageSearchViewController = ImageSearchViewController()
        imageSearchViewController.presenter = presenter
        return imageSearchViewController
    }
}

private extension ImageViewController {
    typealias Presenter = ImagePresenter<ImageViewController>
    
    static var defaultPresenter: Presenter {
        return Presenter()
    }
    
    static func make(presenter: Presenter = defaultPresenter) -> ImageViewController {
        let controller = ImageViewController()
        controller.presenter = presenter
        return controller
    }
}

private class ImageSearchController {
    static func make() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        return searchController
    }
}

class ImageSearchNavigationController: UINavigationController, Router {
    override init(rootViewController: UIViewController = ImageSearchViewController.make()) {
        super.init(rootViewController: rootViewController)
        
        let searchController = ImageSearchController.make()
        rootViewController.navigationItem.hidesSearchBarWhenScrolling = false
        rootViewController.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = rootViewController as? UISearchResultsUpdating
        searchController.searchBar.accessibilityIdentifier = ImageSearchViewAccessibility.searchBar.rawValue
        
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "search-empty"), selectedImage: #imageLiteral(resourceName: "search-filled"))
        tabBarItem.accessibilityLabel = "Search Tab"
        
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
    
    func handle(route: RouteAction) -> Bool {
        switch route {
        case ImageSearchRoute.showImage:
            pushViewController(ImageViewController.make(), animated: true)
            return true
        default: return false
        }
    }
}

