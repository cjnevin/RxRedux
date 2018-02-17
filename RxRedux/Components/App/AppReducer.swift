import Foundation

enum Reducers {
    static func reduce(_ state: AppState, _ action: ActionType) -> AppState {
        return AppState(
            countState: reduce(state.countState, action),
            languageState: reduce(state.languageState, action),
            styleState: reduce(state.styleState, action)
        )
    }
}

struct AppState {
    let countState: CountState
    let languageState: LanguageState
    let styleState: StyleState
    
    static var initialState: AppState {
        return AppState(
            countState: CountState(counter: 0),
            languageState: LanguageState(current: "",
                                         list: [],
                                         listError: nil),
            styleState: StyleState(current: Style(name: ""), list: []))
    }
}

enum AppAction: ActionType {
    case launch
}
