import Foundation

enum PersistenceAction: ActionType {
    case replaceState(AppState)
}

private let persistenceOperationQueue: OperationQueue = {
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 1
    operationQueue.qualityOfService = .userInitiated
    return operationQueue
}()

private let persistenceKey = "Store.AppState"

enum PersistenceMiddleware<S, T: Store<S>> {
    static func create(_ userDefaults: UserDefaults = .standard) -> (T) -> DispatchCreator {
        return { store in
            return { next in
                return { action in
                    if case StoreAction.initialized = action {
                        let decoder = JSONDecoder()
                        if let data = userDefaults.value(forKey: persistenceKey) as? Data,
                            let appState = try? decoder.decode(AppState.self, from: data) {
                            store.dispatch(PersistenceAction.replaceState(appState))
                        }
                    }
                    next(action)
                    let state = store.state
                    persistenceOperationQueue.addOperation {
                        if let state = state as? AppState {
                            let jsonEncoder = JSONEncoder()
                            guard let encoded = try? jsonEncoder.encode(state) else {
                                debugPrint("Invalid JSON, cannot persist")
                                return
                            }
                            // Note: User Defaults synchronizes automatically at regular intervals.
                            // However, sometimes if you kill the app prematurely it won't have written yet.
                            // User defaults should be avoided in practice.
                            userDefaults.setValue(encoded, forKey: persistenceKey)
                        }
                    }
                }
            }
        }
    }
}
