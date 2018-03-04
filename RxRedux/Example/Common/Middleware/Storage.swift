import Foundation

enum PersistenceAction: ActionType {
    case replaceState(AppState)
}

class Storage {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    private let persistenceOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()
    
    private let persistenceKey = "Store.AppState"

    func initialState() -> AppState {
        guard let data = userDefaults.value(forKey: persistenceKey) as? Data,
            let appState = try? JSONDecoder().decode(AppState.self, from: data) else {
                return AppState()
        }
        return appState
    }
    
    func sideEffect(_ store: Store<AppState>, _ action: ActionType) {
        persistenceOperationQueue.cancelAllOperations()
        persistenceOperationQueue.addOperation { [weak self] in
            guard let `self` = self else { return }
            guard let encoded = try? JSONEncoder().encode(store.state) else {
                debugPrint("Invalid JSON, cannot persist")
                return
            }
            // Note: User Defaults synchronizes automatically at regular intervals.
            // However, sometimes if you kill the app prematurely it won't have written yet.
            // User defaults should be avoided in practice.
            self.userDefaults.setValue(encoded, forKey: self.persistenceKey)
        }
    }
}

