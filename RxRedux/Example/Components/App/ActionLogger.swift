import Foundation

class ActionLogger {
    func sideEffect<S: StateType>(_ state: S, _ action: ActionType) {
        debugPrint("didDispatch \(action)")
    }
}
