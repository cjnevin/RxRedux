import Foundation
import Nimble
import XCTest
@testable import RxRedux

class LanguageStateTests: XCTestCase {
    func test_whenApplied_thenExpectLanguageChange() {
        var sut = LanguageState(current: "", list: [])
        let mappings: [(LanguageAction, () -> Bool)] = [
            (LanguageAction.list(.complete(["en"])), { sut.list == ["en"] }),
            (LanguageAction.list(.loading), { sut.list == [] }),
            (LanguageAction.changeTo("fr"), { sut.current == "" }),
            (LanguageAction.applied("fr"), { sut.current == "fr" }),
            (LanguageAction.changeTo("en"), { sut.current == "fr" })
        ]
        mappings.forEach { (action, expectation) in
            sut.reduce(action)
            expect(expectation()).to(beTrue(), description: "\(action) mapping failed")
        }
    }
}

