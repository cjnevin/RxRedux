import Nimble
import Nimble_Snapshots
@testable import RxRedux

class ViewControllerTestCase: ReduxTestCase {
    var recordMode: Bool = false
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        setLanguageToEnglish()
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }

    override func tearDown() {
        super.tearDown()
        window = nil
    }
    
    func setLanguageToEnglish() {
        prepareMockState(hasLanguageManager: true).disposed(by: disposeBag)
        fire.onNext(LanguageAction.changeTo("en"))
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
            .toEventually(haveValidSnapshot(named: sanitise(name)))
    }
    
    private func sanitise(_ name: String) -> String {
        let invalid: [Character] = ["(", ")"]
        return name.filter({ !invalid.contains($0) })
    }
    
    func expectGreenStyle(_ name: String = #function, file: FileString = #file, line: UInt = #line) {
        fire.onNext(StyleAction.set(Style(styleType: .green)))
        expectValidSnapshot(name, file: file, line: line)
        fire.onNext(StyleAction.set(Style(styleType: .blue)))
    }
}
