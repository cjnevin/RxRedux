import Nimble
import Nimble_Snapshots
@testable import RxRedux

private func resetStore() {
    store = Store<AppState>(
        state: AppState(),
        middlewares: [
            StyleMiddleware.create()
        ])
}

class ReduxTestCase: XCTestCase {
    override func setUp() {
        super.setUp()
        resetStore()
    }
}
