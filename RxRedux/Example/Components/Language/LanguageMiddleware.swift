import Foundation
import Localize_Swift

protocol LanguageManaging {
    func current() -> String
    func list() -> [String]
    func set(language: String)
}

class LanguageManager: LanguageManaging {
    func current() -> String {
        return Localize.currentLanguage()
    }
    
    func list() -> [String] {
        return Localize.availableLanguages(true)
    }
    
    func set(language: String) {
        Localize.setCurrentLanguage(language)
    }
}

enum LanguageMiddleware<S, T: Store<S>> {
    static func create(manager: LanguageManaging = LanguageManager()) -> (T) -> DispatchCreator {
        return { store in
            return { next in
                return { action in
                    switch action {
                    case AppLifecycleAction.launch(_):
                        store.dispatch(LanguageAction.set(manager.current()))
                        next(action)
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
