import Foundation

enum LanguageAction: ActionType {
    case list(Progress<[String]>)
    case set(String)
    
    static func getList() -> ActionType {
        return LanguageAction.list(.loading)
    }
}

struct LanguageState: StateType {
    private(set) var current: String
    private(set) var list: [String]
    
    mutating func reduce(_ action: ActionType) {
        switch action {
        case LanguageAction.set(let newLanguage):
            current = newLanguage
        case LanguageAction.list(.loading):
            list = []
        case LanguageAction.list(.complete(let newList)):
            list = newList
        default:
            break
        }
    }
}
