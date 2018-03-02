import Foundation
import Localize_Swift

protocol LanguageManaging {
    func systemLanguage() -> String
    func list() -> [String]
    func set(language: String)
}

extension LanguageManaging {
    func sideEffect(_ state: AppState, _ action: ActionType) {
        sideEffect(state.languageState, action)
    }

    func sideEffect(_ state: LanguageState, _ action: ActionType) {
        switch action {
        case AppLifecycleAction.ready:
            if list().contains(state.current) {
                fire.onNext(LanguageAction.changeTo(state.current))
            } else {
                fire.onNext(LanguageAction.changeTo(systemLanguage()))
            }
        case LanguageAction.list(.loading):
            fire.onNext(LanguageAction.list(.complete(list())))
        case LanguageAction.changeTo(let language):
            set(language: language)
            fire.onNext(LanguageAction.applied(language))
        default:
            break
        }
    }
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

