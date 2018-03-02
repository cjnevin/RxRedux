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
        fire.onNext(AppLifecycleAction.ready)
        expectValidSnapshot()
    }
    
    func test_whenBlueCellIsTapped_thenStyleValueIsChanged() {
        fire.onNext(AppLifecycleAction.ready)
        fire.onNext(StyleAction.set(Style(styleType: .green)))
        blueCell.tap()
        expectValidSnapshot()
    }
    
    func test_whenGreenCellIsTapped_thenStyleValueIsChanged() {
        fire.onNext(AppLifecycleAction.ready)
        greenCell.tap()
        expectValidSnapshot()
        fire.onNext(StyleAction.set(Style(styleType: .blue)))
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

