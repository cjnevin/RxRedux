import Foundation

struct Logger {
    func sideEffect(_ store: Store<AppState>, _ action: ActionType) {
        debugPrint("didDispatch \(action)")
    }
}
