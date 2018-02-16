import FBSnapshotTestCase
@testable import RxRedux

func resetStore() {
    store = Store<AppState>(reducer: Reducers.reduce, state: AppState.initialState, middleware: [])
}

class RxReduxTestCase: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        resetStore()
        isDeviceAgnostic = true
    }
}
