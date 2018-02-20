import Nimble
import Nimble_Snapshots
@testable import RxRedux

private func resetStore() {
    store = Store<AppState>(
        reducer: Reducers.reduce,
        state: AppState.initialState,
        middlewares: [
            StyleMiddleware.create(manager: StyleManager(userDefaults: MockUserDefaults()))
        ])
}

class ReduxTestCase: XCTestCase {
    override func setUp() {
        super.setUp()
        resetStore()
    }
}
