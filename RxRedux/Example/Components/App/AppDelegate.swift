import UIKit
import RxSwift

var router = RoutingMiddleware<AppState, Store<AppState>>(routers: [
    ExternalLinkRouter()
])

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
    let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = TabBarController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        store.dispatch(AppLifecycleAction.launch(launchOptions))
        
        store.uniquelyObserve(\.networkState.isLoading)
            .debounce(0.5, scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { (isLoading) in
                application.isNetworkActivityIndicatorVisible = isLoading
            })
            .disposed(by: disposeBag)
        
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

