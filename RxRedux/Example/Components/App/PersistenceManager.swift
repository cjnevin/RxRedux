import Foundation

class PersistenceManager {
    private let writeQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()

    private let persistenceKey = "Store.AppState"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func restore() -> AppState {
        guard let data = userDefaults.value(forKey: persistenceKey) as? Data,
            let appState = try? JSONDecoder().decode(AppState.self, from: data) else {
                return AppState()
        }
        return appState
    }

    func sideEffect<S: StateType & Encodable>(_ state: S, action: ActionType) {
        writeQueue.addOperation { [weak self] in
            guard let `self` = self else { return }
            guard let encoded = try? JSONEncoder().encode(state) else {
                debugPrint("Invalid JSON, cannot persist")
                return
            }
            // Note: User Defaults synchronizes automatically at regular intervals.
            // However, sometimes if you kill the app prematurely it won't have written yet.
            self.userDefaults.setValue(encoded, forKey: self.persistenceKey)
        }
    }
}
