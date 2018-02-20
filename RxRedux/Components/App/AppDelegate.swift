import UIKit

let router = RoutingMiddleware<AppState, Store<AppState>>()

var store = Store<AppState>(
    reducer: Reducers.reduce,
    state: AppState.initialState,
    middlewares: [
        LanguageMiddleware.create(),
        LoggingMiddleware.create(),
        router.create(),
        StyleMiddleware.create()
    ])

typealias LaunchOptionsKey = UIApplicationLaunchOptionsKey

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = TabBarController()
        
        router.add(router: ExternalLinkRouter())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        store.dispatch(AppLifecycleAction.launch(launchOptions))
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        store.dispatch(AppLifecycleAction.background)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        store.dispatch(AppLifecycleAction.foreground)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        store.dispatch(AppLifecycleAction.inactive)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        store.dispatch(AppLifecycleAction.active)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        store.dispatch(AppLifecycleAction.terminating)
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        store.dispatch(AppLifecycleAction.memoryWarning)
    }
}

