import Foundation
import Nimble
import XCTest
import RxSwift
import RxNimble
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
    var subject: PublishSubject<ActionType>!
    var sut: Observable<LanguageState>!
    var manager: LanguageManagerMock!
    
    func test_whenSetAction_thenExpectLanguageToBeSet() {
        expect(self.sut.map { $0.current }).first == ""
        subject.onNext(LanguageAction.changeTo("fr"))
        expect(self.sut.map { $0.current }).first == "fr"
    }
    
    func test_whenGetListAction_thenExpectWhatManagerContains() {
        expect(self.sut.map { $0.list }).first == []
        subject.onNext(LanguageAction.getList())
        expect(self.sut.map { $0.list }).first == ["en"]
    }
    
    override func setUp() {
        super.setUp()
        manager = LanguageManagerMock()
        subject = PublishSubject<ActionType>()
        sut = LanguageState(current: "", list: []).loop(on: subject, with: [manager.sideEffect])
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        manager = nil
    }
}

