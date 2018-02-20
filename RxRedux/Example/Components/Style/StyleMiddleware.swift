import Foundation

enum StyleMiddleware<S, T: Store<S>> {
    static func create(manager: StyleManaging = StyleManager()) -> (T) -> DispatchCreator {
        return { store in
            return { next in
                return { action in
                    switch action {
                    case AppLifecycleAction.launch(_):
                        store.dispatch(StyleAction.set(manager.current()))
                        next(action)
                    case StyleAction.list(.loading):
                        next(action)
                        store.dispatch(StyleAction.list(.complete(manager.list())))
                    case StyleAction.set(let style):
                        style.apply()
                        style.refresh()
                        manager.set(style: style)
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

