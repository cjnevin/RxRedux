import Foundation

enum Reducers {
    static func reduce(_ state: AppState, _ action: ActionType) -> AppState {
        return AppState(
            countState: reduce(state.countState, action),
            imageState: reduce(state.imageState, action),
            languageState: reduce(state.languageState, action),
            styleState: reduce(state.styleState, action)
        )
    }
}

struct AppState {
    let countState: CountState
    let imageState: ImageSearchState
    let languageState: LanguageState
    let styleState: StyleState
    
    static var initialState: AppState {
        return AppState(
            countState: CountState(counter: 0),
            imageState: ImageSearchState(results: [], selected: nil),
            languageState: LanguageState(current: "", list: []),
            styleState: StyleState(current: Style(name: ""), list: []))
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
