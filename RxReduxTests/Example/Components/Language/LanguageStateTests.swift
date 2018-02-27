import Foundation
import Nimble
import XCTest
@testable import RxRedux

class LanguageManagerMock: LanguageManaging {
    func systemLanguage() -> String {
        return currentSpy.get()!
    }

    let listMock = Mock(["en"])
    func list() -> [String] {
        return listMock.execute()
    }
    
    let currentSpy = Spy("en")
    func set(language: String) {
        currentSpy.set(language)
    }
}

class LanguageStateTests: XCTestCase {
    var sut: Store<LanguageState>!
    var manager: LanguageManagerMock!
    
    func test_whenSetAction_thenExpectLanguageToBeSet() {
        expect(self.sut.state.current).to(equal(""))
        sut.dispatch(LanguageAction.set("fr"))
        expect(self.sut.state.current).to(equal("fr"))
    }
    
    func test_whenGetListAction_thenExpectWhatManagerContains() {
        expect(self.sut.state.list).to(equal([]))
        sut.dispatch(LanguageAction.getList())
        expect(self.sut.state.list).toEventually(equal(["en"]))
    }
    
    override func setUp() {
        super.setUp()
        sut = Store<LanguageState>(state: LanguageState(current: "", list: []))
        manager = LanguageManagerMock()
        sut.register(LanguageMiddleware.create(manager: manager))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        manager = nil
    }
}

