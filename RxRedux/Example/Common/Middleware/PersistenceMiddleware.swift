import Foundation

private let persistenceOperationQueue: OperationQueue = {
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 1
    operationQueue.qualityOfService = .userInitiated
    return operationQueue
}()

private let persistenceKey = "Store.AppState"

func getAppState(_ userDefaults: UserDefaults = .standard) -> AppState {
    let decoder = JSONDecoder()
    if let data = userDefaults.value(forKey: persistenceKey) as? Data,
        let appState = try? decoder.decode(AppState.self, from: data) {
        return appState
    }
    return AppState()
}

enum PersistenceMiddleware {
    static func create(_ userDefaults: UserDefaults = .standard) -> (AppState) -> DispatchCreator {
        return { state in
            return { next in
                return { action in
                    next(action)
                    persistenceOperationQueue.addOperation {
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
