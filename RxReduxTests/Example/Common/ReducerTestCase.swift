import Nimble
import Nimble_Snapshots
import RxSwift
@testable import RxRedux

func prepareMockState(
    hasStyleManager: Bool = true,
    hasLanguageManager: Bool = false,
    hasActionLogger: Bool = false,
    coordinator: AppCoordinator? = nil) -> Disposable {
    fire = PublishSubject<ActionType>()
    state = AppState().loop(on: fire, with: [
        hasStyleManager ? StyleManager().sideEffect : nil,
        hasLanguageManager ? LanguageManager().sideEffect : nil,
        hasActionLogger ? ActionLogger().sideEffect : nil,
        coordinator != nil ? coordinator!.sideEffect : nil
    ].flatMap { $0 })
    return state.subscribe()
}

class ReduxTestCase: XCTestCase {
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        prepareMockState().disposed(by: disposeBag)
    }
    
    override func tearDown() {
        super.tearDown()
        disposeBag = nil
    }
}
