import Foundation

struct LoggingMiddleware<S, T: Store<S>> {
    func create() -> (T) -> DispatchCreator {
        return { store in
            return { next in
                return { action in
                    print("willDispatch \(action) -> \(store.state)")
                    next(action)
                    print("didDispatch \(action) -> \(store.state)")
                }
            }
        }
    }
}
