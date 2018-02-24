import Nimble
import Nimble_Snapshots
@testable import RxRedux

private func resetStore() {
    store = Store<AppState>(
        state: AppState.initialState,
        middlewares: [
            StyleMiddleware.create(manager: StyleManager(userDefaults: MockUserDefaults()))
        ])
}

class ViewControllerTestCase: XCTestCase {
    var recordMode: Bool = false
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        resetStore()
        setLanguageToEnglish()
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }

    override func tearDown() {
        super.tearDown()
        window = nil
    }
    
    func setLanguageToEnglish() {
        store.register(LanguageMiddleware.create())
        store.dispatch(LanguageAction.set("en"))
    }
    
    func recordNewSnapshot(_ name: String = #function, file: FileString = #file, line: UInt = #line) {
        expect(self.window, file: file, line: line)
            .to(recordSnapshot(named: sanitise(name)))
    }
    
    func expectValidSnapshot(_ name: String = #function, file: FileString = #file, line: UInt = #line) {
        if recordMode {
            recordNewSnapshot(name, file: file, line: line)
            return
        }
        expect(self.window, file: file, line: line)
            .to(haveValidSnapshot(named: sanitise(name)))
    }
    
    private func sanitise(_ name: String) -> String {
        let invalid: [Character] = ["(", ")"]
        return name.filter({ !invalid.contains($0) })
    }
    
    func expectGreenStyle(_ name: String = #function, file: FileString = #file, line: UInt = #line) {
        store.dispatch(StyleAction.set(GreenStyle()))
        expectValidSnapshot(name, file: file, line: line)
        store.dispatch(StyleAction.set(BlueStyle()))
    }
}
