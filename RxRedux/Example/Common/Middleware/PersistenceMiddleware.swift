import Foundation

enum PersistenceMiddleware<S, T: Store<S>> {
    static func create(_ userDefaults: UserDefaults = .standard) -> (T) -> DispatchCreator {
        return { dispatchStore in
            return { next in
                return { action in
                    if case AppLifecycleAction.launch(_) = action {
                        let decoder = JSONDecoder()
                        if let data = userDefaults.value(forKey: "state") as? Data,
                           let appState = try? decoder.decode(AppState.self, from: data) {
                            store.replace(appState)
                        }
                    }
                    next(action)
                    if let state = dispatchStore.state as? AppState {
                        let jsonEncoder = JSONEncoder()
                        guard let encoded = try? jsonEncoder.encode(state) else {
                            debugPrint("Invalid JSON, cannot persist")
                            return
                        }
                        userDefaults.setValue(encoded, forKey: "state")
                        userDefaults.synchronize()
                    }
                }
            }
        }
    }
}
