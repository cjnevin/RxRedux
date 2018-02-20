import Foundation

enum StyleAction: ActionType {
    case list(Progress<[Style]>)
    case set(Style)
    
    static func getList() -> ActionType {
        return StyleAction.list(.loading)
    }
}

extension Reducers {
    static func reduce(_ state: StyleState, _ action: ActionType) -> StyleState {
        var state = state
        switch action {
        case StyleAction.set(let newStyle):
            state.current = newStyle
        case StyleAction.list(.loading):
            state.list = []
        case StyleAction.list(.complete(let newList)):
            state.list = newList
        default:
            break
        }
        return state
    }
}

struct StyleState {
    var current: Style
    var list: [Style]
}

