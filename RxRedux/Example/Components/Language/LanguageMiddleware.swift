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

enum LanguageMiddleware {
    static func create(manager: LanguageManaging = LanguageManager()) -> (AppState) -> DispatchCreator {
        return { state in
            return { next in
                return { action in
                    switch action {
                    case AppLifecycleAction.ready:
                        if manager.list().contains(state.languageState.current) {
                            store.dispatch(LanguageAction.set(state.languageState.current))
                        } else {
                            store.dispatch(LanguageAction.set(manager.systemLanguage()))
                        }
                        next(action)
                    case LanguageAction.list(.loading):
                        next(action)
                        store.dispatch(LanguageAction.list(.complete(manager.list())))
                    case LanguageAction.set(let language):
                        manager.set(language: language)
                        next(action)
                    default:
                        next(action)
                    }
                }
            }
        }
    }
}
