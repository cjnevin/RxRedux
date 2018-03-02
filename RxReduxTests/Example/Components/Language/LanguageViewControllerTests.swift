import Nimble
import Nimble_Snapshots
import KIF
@testable import RxRedux

class LanguageViewControllerTests: ViewControllerTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
        let navigationController = LanguageNavigationController()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController]
        window.rootViewController = tabBarController
    }
    
    func test_whenLanguageViewIsCreated_thenExpectEnglishIsSelected() {
        expectValidSnapshot()
    }
    
    func test_whenStyleIsSetToGreen_thenExpectItIsApplied() {
        expectGreenStyle()
    }
    
    func test_whenEnglishCellIsTapped_thenLanguageValueIsChanged() {
        fire.onNext(AppLifecycleAction.ready)
        tester().waitForView(withAccessibilityLabel: "en")
        frenchCell.tap() // Change language first
        englishCell.tap()
        expectValidSnapshot()
    }
    
    func test_whenFrenchCellIsTapped_thenLanguageValueIsChanged() {
        fire.onNext(AppLifecycleAction.ready)
        frenchCell.tap()
        expectValidSnapshot()
    }
    
    func test_whenJapaneseCellIsTapped_thenLanguageValueIsChanged() {
        fire.onNext(AppLifecycleAction.ready)
        japaneseCell.tap()
        expectValidSnapshot()
    }
    
    // MARK: Helpers
    
    var languageCells: KIFUIViewTestActor {
        return viewTester().usingIdentifier(LanguageCellAccessibility.languageCell.rawValue)
    }
    
    var englishCell: KIFUIViewTestActor {
        return viewTester().usingLabel("en")
    }
    
    var frenchCell: KIFUIViewTestActor {
        return viewTester().usingLabel("fr")
    }
    
    var japaneseCell: KIFUIViewTestActor {
        return viewTester().usingLabel("ja")
    }
}
