import Foundation

struct AppState: StateType {
    private(set) var countState: CountState
    private(set) var imageState: ImageState
    private(set) var languageState: LanguageState
    private(set) var signInState: SignInState
    private(set) var styleState: StyleState
    
    static var initialState: AppState {
        return AppState(
            countState: CountState(counter: 0),
            imageState: ImageState(images: [], imagesError: nil, selected: nil),
            languageState: LanguageState(current: "", list: []),
            signInState: SignInState(),
            styleState: StyleState(current: Style(name: ""), list: []))
    }
    
    mutating func reduce(_ action: ActionType) {
        countState.reduce(action)
        imageState.reduce(action)
        languageState.reduce(action)
        signInState.reduce(action)
        styleState.reduce(action)
    }
}

enum AppLifecycleAction: ActionType {
    /// didFinishLaunchingWithOptions
    case launch([LaunchOptionsKey: Any]?)
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

