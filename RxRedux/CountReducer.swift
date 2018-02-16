import Foundation

enum CountAction: ActionType {
    case increment
    case decrement
}

struct CountState {
    var counter: Int
}

extension Reducers {
    static func reduce(_ state: CountState, _ action: ActionType) -> CountState {
        var state = state
        switch action {
        case CountAction.decrement: state.counter -= 1
        case CountAction.increment: state.counter += 1
        default: break
        }
        return state
    }
}
