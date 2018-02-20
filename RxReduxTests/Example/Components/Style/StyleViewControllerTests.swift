import Nimble
import Nimble_Snapshots
import KIF
@testable import RxRedux

class StyleViewControllerTests: ViewControllerTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
        let navigationController = StyleNavigationController()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController]
        window.rootViewController = tabBarController
    }
    
    func test_whenAppIsLaunched_thenExpectBlueIsSelected() {
        store.dispatch(AppLifecycleAction.launch(nil))
        expectValidSnapshot()
    }
    
    func test_whenBlueCellIsTapped_thenStyleValueIsChanged() {
        store.dispatch(AppLifecycleAction.launch(nil))
        store.dispatch(StyleAction.set(GreenStyle()))
        blueCell.tap()
        expectValidSnapshot()
    }
    
    func test_whenGreenCellIsTapped_thenStyleValueIsChanged() {
        store.dispatch(AppLifecycleAction.launch(nil))
        greenCell.tap()
        expectValidSnapshot()
        store.dispatch(StyleAction.set(BlueStyle()))
    }
    
    // MARK: Helpers
    
    var styleCells: KIFUIViewTestActor {
        return viewTester().usingIdentifier(StyleCellAccessibility.styleCell.rawValue)
    }
    
    var blueCell: KIFUIViewTestActor {
        return viewTester().usingLabel("Blue")
    }
    
    var greenCell: KIFUIViewTestActor {
        return viewTester().usingLabel("Green")
    }
}

