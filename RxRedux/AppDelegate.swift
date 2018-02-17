import UIKit
import RxSwift

var store = Store<AppState>(
    reducer: Reducers.reduce,
    state: AppState.initialState)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        store.register(LoggingMiddleware<AppState, Store<AppState>>.create())
        
        let presenter = CountPresenter<CountViewController>()
        let viewController = CountViewController()
        viewController.presenter = presenter
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
