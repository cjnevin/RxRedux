import Nimble
import Nimble_Snapshots
import KIF
@testable import RxRedux

class CountViewControllerTests: ViewControllerTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
        let countNavigationController = CountNavigationController()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [countNavigationController]
        window.rootViewController = tabBarController
    }
    
    func test_whenCountViewIsCreated_thenItAppearsAsExpected() {
        expectValidSnapshot()
    }
    
    func test_whenIncrementButtonIsTapped_thenCountValueIsChanged() {
        increment.tap()
        expectValidSnapshot()
    }
    
    func test_whenDecrementButtonIsTapped_thenCountValueIsChanged() {
        decrement.tap()
        expectValidSnapshot()
    }
    
    func test_whenStyleIsSetToGreen_thenExpectItIsApplied() {
        expectGreenStyle()
    }
    
    // MARK: Helpers
    
    var decrement: KIFUIViewTestActor {
        return viewTester().usingIdentifier(CountViewAccessibility.countDecrement.rawValue)
    }
    
    var increment: KIFUIViewTestActor {
        return viewTester().usingIdentifier(CountViewAccessibility.countIncrement.rawValue)
    }
}
