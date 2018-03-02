import Nimble
import Nimble_Snapshots
import RxSwift
@testable import RxRedux

func prepareMockState(
    hasStyleManager: Bool = true,
    hasLanguageManager: Bool = false,
    hasActionLogger: Bool = false,
    coordinator: AppCoordinator? = nil) {
    state = AppState().loop(on: fire, with: [
        hasStyleManager ? StyleManager().sideEffect : nil,
        hasLanguageManager ? LanguageManager().sideEffect : nil,
        hasActionLogger ? ActionLogger().sideEffect : nil,
        coordinator != nil ? coordinator!.sideEffect : nil
    ].flatMap { $0 })
}

class ReduxTestCase: XCTestCase {
    override func setUp() {
        super.setUp()
        prepareMockState()
    }
}
