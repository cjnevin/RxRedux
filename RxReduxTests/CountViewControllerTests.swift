import FBSnapshotTestCase
import KIF
@testable import RxRedux

class CountViewControllerTests: RxReduxTestCase {
    var presenter: CountPresenter<CountViewController>!
    var sut: CountViewController!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        resetStore()
        presenter = CountPresenter<CountViewController>()
        sut = CountViewController()
        sut.presenter = presenter
        _ = sut.view
        presenter.attachView(sut)
    }
    
    override func tearDown() {
        super.tearDown()
        resetStore()
        sut = nil
        presenter = nil
    }
    
    func test_whenCountViewIsCreated_thenItAppearsAsExpected() {
        FBSnapshotVerifyView(sut.view)
    }
    
    func test_whenIncrementButtonIsTapped_thenCountValueIsChanged() {
        incrementButton.tap()
        FBSnapshotVerifyView(sut.view)
    }
    
    func test_whenDecrementButtonIsTapped_thenCountValueIsChanged() {
        decrementButton.tap()
        FBSnapshotVerifyView(sut.view)
    }
    
    // MARK: Helpers
    
    var decrementButton: KIFUIViewTestActor {
        return viewTester().usingIdentifier(CountViewAccessibility.countDecrementButton.rawValue)
    }
    
    var incrementButton: KIFUIViewTestActor {
        return viewTester().usingIdentifier(CountViewAccessibility.countIncrementButton.rawValue)
    }
}
