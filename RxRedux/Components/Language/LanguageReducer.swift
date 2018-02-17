import Foundation

enum Progress<T> {
    case loading
    case success(T)
    case failure(Error)
}

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
        case LanguageAction.list(let progress):
            switch progress {
            case .loading:
                state.list = []
                state.listError = nil
            case .success(let newOptions):
                state.list = newOptions
            case .failure(let error):
                state.listError = error
            }
        default:
            break
        }
        return state
    }
}

struct LanguageState {
    var current: String
    var list: [String]
    var listError: Error?
}
