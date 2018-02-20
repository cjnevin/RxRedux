import Foundation

struct NetworkState {
    var isLoading: Bool
}

enum NetworkAction: ActionType {
    case loading(Bool)
}

extension Reducers {
    static func reduce(_ state: NetworkState, _ action: ActionType) -> NetworkState {
        var state = state
        switch action {
        case NetworkAction.loading(let isLoading):
            state.isLoading = isLoading
        default: break
        }
        return state
    }
}
