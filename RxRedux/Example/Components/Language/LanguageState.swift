import Foundation

enum LanguageAction: ActionType {
    case changeTo(String)
    case list(Progress<[String]>)
    case applied(String)
    
    static func getList() -> ActionType {
        return LanguageAction.list(.loading)
    }
}

struct LanguageState: StateType, Equatable, Codable {
    static func ==(lhs: LanguageState, rhs: LanguageState) -> Bool {
        return lhs.current == rhs.current &&
            lhs.list == rhs.list
    }
    
    private(set) var current: String = ""
    private(set) var list: [String] = []
    
    mutating func reduce(_ action: ActionType) {
        switch action {
        case LanguageAction.applied(let newLanguage):
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
