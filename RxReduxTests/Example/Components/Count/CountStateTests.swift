import Foundation
import Nimble
import XCTest
@testable import RxRedux

class CountStateTests: XCTestCase {
    var sut: CountState!
    
    func test_whenIncrementAction_thenExpectCounterToIncrease() {
        expect(self.sut.counter) == 0
        sut.reduce(CountAction.increment)
        expect(self.sut.counter) == 1
    }
    
    func test_whenDecrementAction_thenExpectCounterToDecrease() {
        expect(self.sut.counter) == 0
        sut.reduce(CountAction.decrement)
        expect(self.sut.counter) == -1
    }
    
    override func setUp() {
        super.setUp()
        sut = CountState(counter: 0)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
