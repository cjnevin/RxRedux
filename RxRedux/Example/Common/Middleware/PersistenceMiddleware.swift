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

enum PersistenceMiddleware<S, T: Store<S>> {
    static func create(_ userDefaults: UserDefaults = .standard) -> (T) -> DispatchCreator {
        return { store in
            return { next in
                return { action in
                    if case StoreAction.initialized = action {
                        let decoder = JSONDecoder()
                        if let data = userDefaults.value(forKey: "state") as? Data,
                            let appState = try? decoder.decode(AppState.self, from: data) {
                            store.dispatch(PersistenceAction.replaceState(appState))
                        }
                    }
                    next(action)
                    let state = store.state
                    persistenceOperationQueue.cancelAllOperations()
                    persistenceOperationQueue.addOperation {
                        if let state = state as? AppState {
                            let jsonEncoder = JSONEncoder()
                            guard let encoded = try? jsonEncoder.encode(state) else {
                                debugPrint("Invalid JSON, cannot persist")
                                return
                            }
                            userDefaults.setValue(encoded, forKey: "state")
                        }
                    }
                }
            }
        }
    }
}
