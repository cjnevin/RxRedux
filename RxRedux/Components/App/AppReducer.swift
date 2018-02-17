import Foundation

enum Reducers {
    static func reduce(_ state: AppState, _ action: ActionType) -> AppState {
        return AppState(
            countState: reduce(state.countState, action)
        )
    }
}

struct AppState {
    let countState: CountState
    
    static var initialState: AppState {
        return AppState(countState: CountState(counter: 0))
    }
}

enum AppAction: ActionType {
    case launch
}
