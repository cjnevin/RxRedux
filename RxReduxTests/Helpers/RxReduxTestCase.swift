import FBSnapshotTestCase
@testable import RxRedux

func resetStore() {
    store = Store<AppState>(reducer: Reducers.reduce, state: AppState.initialState)
}

class RxReduxTestCase: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        resetStore()
        isDeviceAgnostic = true
        assertLanguageIsSupported()
    }
    
    private func assertLanguageIsSupported() {
        let validLanguages = ["en", "en-US"]
        let current = Locale.preferredLanguages[0]
        Swift.assert(validLanguages.contains(current))
    }
}
