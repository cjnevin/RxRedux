import Foundation

struct AppState: StateType, Codable {
    private(set) var countState: CountState
    private(set) var imageState: ImageState
    private(set) var languageState: LanguageState
    private(set) var signInState: SignInState
    private(set) var styleState: StyleState
    
    init() {
        countState = CountState()
        imageState = ImageState()
        languageState = LanguageState()
        signInState = SignInState()
        styleState = StyleState()
    }
    
    mutating func reduce(_ action: ActionType) {
        if case PersistenceAction.replaceState(let state) = action {
            self = state
        } else {
            countState.reduce(action)
            imageState.reduce(action)
            languageState.reduce(action)
            signInState.reduce(action)
            styleState.reduce(action)
        }
    }
}

enum AppLifecycleAction: ActionType {
    /// didFinishLaunchingWithOptions
    case launch([LaunchOptionsKey: Any]?)
    /// didFinishLaunchingWithOptions after screens are ready
    case ready
    /// applicationDidEnterBackground
    case background
    /// applicationWillEnterForeground
    case foreground
    /// applicationWillResignActive
    case inactive
    /// applicationDidBecomeActive
    case active
    /// applicationWillTerminate
    case terminating
    /// applicationDidReceiveMemoryWarning
    case memoryWarning
}

