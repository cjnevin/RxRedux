import Foundation
import Localize_Swift

struct LanguageManagerMiddleware<S, T: Store<S>> {
    static func create() -> (T) -> DispatchCreator {
        return { store in
            return { next in
                return { action in
                    switch action {
                    case AppAction.launch:
                        store.dispatch(LanguageAction.set(Localize.currentLanguage()))
                        next(action)
                    case LanguageAction.list(.loading):
                        next(action)
                        store.dispatch(LanguageAction.list(.success(Localize.availableLanguages().filter({ $0 != "Base" }))))
                    case LanguageAction.set(let language):
                        Localize.setCurrentLanguage(language)
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
