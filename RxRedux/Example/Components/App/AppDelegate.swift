import UIKit
import RxSwift

var api: Api = Api()

var router = Coordinator<AppState, Store<AppState>>(routers: [
    ExternalLinkRouter()
])

private let storage = Storage()

var store = Store<AppState>(
    state: storage.initialState(),
    sideEffects: [
        LanguageMiddleware().sideEffect,
        Logger().sideEffect,
        router.sideEffect,
        Styler().sideEffect,
        storage.sideEffect
    ])

// Used by AppReducer, avoids importing UIKit everywhere
typealias LaunchOptionsKey = UIApplicationLaunchOptionsKey

var isUnitTesting: Bool = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let value = ProcessInfo.processInfo.environment["UNIT_TESTING"], Int(value) == 1 {
            isUnitTesting = true
            //return true
        }
        
        store.dispatch(AppLifecycleAction.launch(launchOptions))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        store.dispatch(AppLifecycleAction.ready)
        
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

