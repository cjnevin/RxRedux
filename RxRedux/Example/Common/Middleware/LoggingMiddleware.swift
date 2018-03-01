import Foundation

enum LoggingMiddleware<State> {
    static func create() -> (State) -> DispatchCreator {
        return { state in
            return { next in
                return { action in
                    //debugPrint("willDispatch \(action)")
                    next(action)
                    debugPrint("didDispatch \(action)")
                }
            }
        }
    }
}
