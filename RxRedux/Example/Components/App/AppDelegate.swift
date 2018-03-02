import UIKit
import RxSwift

private let disposeBag = DisposeBag()
private let persistence = PersistenceManager()
private let sideEffects: [SideEffect<AppState>] =
    [
        LanguageManager().sideEffect,
        ActionLogger().sideEffect,
        StyleManager().sideEffect,
        coordinator.sideEffect,
        persistence.sideEffect
]

let api: Api = Api()
let coordinator = AppCoordinator(routers: [ExternalLinkRouter()])
var state: Observable<AppState> = persistence.restore().loop(on: fire, with: sideEffects)

// Used by AppReducer, avoids importing UIKit everywhere
typealias LaunchOptionsKey = UIApplicationLaunchOptionsKey

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        state.subscribe().disposed(by: disposeBag)

        fire.onNext(AppLifecycleAction.launch(launchOptions))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        fire.onNext(AppLifecycleAction.ready)
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        fire.onNext(AppLifecycleAction.background)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        fire.onNext(AppLifecycleAction.foreground)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        fire.onNext(AppLifecycleAction.inactive)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        fire.onNext(AppLifecycleAction.active)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        fire.onNext(AppLifecycleAction.terminating)
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        fire.onNext(AppLifecycleAction.memoryWarning)
    }
}

