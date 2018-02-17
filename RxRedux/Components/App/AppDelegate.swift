import UIKit
import RxSwift

var store = Store<AppState>(
    reducer: Reducers.reduce,
    state: AppState.initialState,
    middlewares: [
        LanguageManagerMiddleware.create(),
        LoggingMiddleware.create(),
        StyleManagerMiddleware.create()
    ])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // MARK: COUNT
        
        let countViewController = CountViewController()
        let countPresenter = CountPresenter<CountViewController>()
        countPresenter.attachPresenters([
            TitlablePresenter(localizationKey: "count.title"),
            TabbablePresenter(localizationKey: "count.tab.title")
        ])
        countViewController.presenter = countPresenter
        
        let countNavigationController = UINavigationController(rootViewController: countViewController)
        countNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "counter-empty"), selectedImage: #imageLiteral(resourceName: "counter-filled"))
        
        
        // MARK: STYLE
        let styleViewController = StyleViewController()
        let stylePresenter = StylePresenter<StyleViewController>()
        stylePresenter.attachPresenters([
            TitlablePresenter(localizationKey: "style.title"),
            TabbablePresenter(localizationKey: "style.tab.title")
            ])
        styleViewController.presenter = stylePresenter
        
        let styleNavigationController = UINavigationController(rootViewController: styleViewController)
        styleNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "theme-empty"), selectedImage: #imageLiteral(resourceName: "theme-filled"))
        
        // Force load of view
        _ = styleViewController.view
        
        // MARK: LANGUAGE
        
        let languageViewController = LanguageViewController()
        let languagePresenter = LanguagePresenter<LanguageViewController>()
        languagePresenter.attachPresenters([
            TitlablePresenter(localizationKey: "language.title"),
            TabbablePresenter(localizationKey: "language.tab.title")
        ])
        languageViewController.presenter = languagePresenter
        
        let languageNavigationController = UINavigationController(rootViewController: languageViewController)
        languageNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "language-empty"), selectedImage: #imageLiteral(resourceName: "language-filled"))
        
        // Force load of view
        _ = languageViewController.view
        
        
        // MARK: TABS
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [countNavigationController, styleNavigationController, languageNavigationController]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        store.dispatch(AppAction.launch)
        
        return true
    }
}

