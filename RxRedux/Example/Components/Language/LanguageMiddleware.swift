import Foundation
import Localize_Swift

protocol LanguageManaging {
    func list() -> [String]
    func set(language: String)
}

class LanguageManager: LanguageManaging {
    func list() -> [String] {
        return Localize.availableLanguages(true)
    }
    
    func set(language: String) {
        Localize.setCurrentLanguage(language)
    }
}

enum LanguageMiddleware<S, T: Store<S>> {
    static func create(manager: LanguageManaging = LanguageManager()) -> (T) -> DispatchCreator {
        return { _ in
            return { next in
                return { action in
                    switch action {
                    case AppLifecycleAction.ready:
                        next(action)
                        store.dispatch(LanguageAction.set(store.state.languageState.current))
                    case LanguageAction.list(.loading):
                        next(action)
                        store.dispatch(LanguageAction.list(.complete(manager.list())))
                    case LanguageAction.set(let language):
                        manager.set(language: language)
                        next(action)
                    default:
                        next(action)
                        break
                    }
                }
            }
        }
    }
}
