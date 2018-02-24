import Foundation

enum StyleAction: ActionType {
    case list(Progress<[Style]>)
    case set(Style)
    
    static func getList() -> ActionType {
        return StyleAction.list(.loading)
    }
}

struct StyleState: StateType {
    private(set) var current: Style
    private(set) var list: [Style]
    
    mutating func reduce(_ action: ActionType) {
        switch action {
        case StyleAction.set(let newStyle):
            current = newStyle
        case StyleAction.list(.loading):
            list = []
        case StyleAction.list(.complete(let newList)):
            list = newList
        default:
            break
        }
    }
}
