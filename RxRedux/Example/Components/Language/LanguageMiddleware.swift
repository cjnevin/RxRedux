import Foundation
import Localize_Swift

protocol LanguageManaging {
    func systemLanguage() -> String
    func list() -> [String]
    func set(language: String)
}

class LanguageManager: LanguageManaging {
    func systemLanguage() -> String {
        return Localize.defaultLanguage()
    }
    
    func list() -> [String] {
        return Localize.availableLanguages(true)
    }
    
    func set(language: String) {
        Localize.setCurrentLanguage(language)
    }
}

class LanguageMiddleware<S, T: Store<S>> {
    private let manager: LanguageManaging
    init(manager: LanguageManaging = LanguageManager()) {
        self.manager = manager
    }
    
    func sideEffect(_ store: T, _ action: ActionType) {
        switch action {
        case AppLifecycleAction.ready:
            if let state = store.state as? AppState {
                if manager.list().contains(state.languageState.current) {
                    store.dispatch(LanguageAction.changeTo(state.languageState.current))
                } else {
                    store.dispatch(LanguageAction.changeTo(manager.systemLanguage()))
                }
            }
        case LanguageAction.list(.loading):
            store.dispatch(LanguageAction.list(.complete(manager.list())))
        case LanguageAction.changeTo(let language):
            manager.set(language: language)
            store.dispatch(LanguageAction.applied(language))
        default:
            break
        }
    }
}
