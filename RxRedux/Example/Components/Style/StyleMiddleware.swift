import Foundation

enum StyleMiddleware {
    static func list() -> [Style] {
        return [Style(styleType: .blue),
                Style(styleType: .green)]
    }
    
    static func create() -> (AppState) -> DispatchCreator {
        return { state in
            return { next in
                return { action in
                    switch action {
                    case AppLifecycleAction.ready:
                        let style = state.styleState.current
                        store.dispatch(StyleAction.set(style))
                        next(action)
                    case StyleAction.list(.loading):
                        next(action)
                        store.dispatch(StyleAction.list(.complete(list())))
                    case StyleAction.set(let style):
                        style.apply()
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

