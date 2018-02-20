import Foundation

enum LanguageAction: ActionType {
    case list(Progress<[String]>)
    case set(String)
    
    static func getList() -> ActionType {
        return LanguageAction.list(.loading)
    }
}

extension Reducers {
    static func reduce(_ state: LanguageState, _ action: ActionType) -> LanguageState {
        var state = state
        switch action {
        case LanguageAction.set(let newLanguage):
            state.current = newLanguage
        case LanguageAction.list(.loading):
            state.list = []
        case LanguageAction.list(.complete(let newList)):
            state.list = newList
        default:
            break
        }
        return state
    }
}

struct LanguageState {
    var current: String
    var list: [String]
}
