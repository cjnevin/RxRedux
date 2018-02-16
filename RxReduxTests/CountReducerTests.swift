import Foundation
import Nimble
import XCTest
@testable import RxRedux

class CountReducerTests: XCTestCase {
    var sut: Store<CountState>!
    
    func test_whenIncrementAction_thenExpectCounterToIncrease() {
        XCTAssertEqual(sut.state.counter, 0)
        (1...5).forEach { expected in
            sut.dispatch(CountAction.increment)
            expect(self.sut.state.counter).to(equal(expected))
        }
    }
    
    func test_whenDecrementAction_thenExpectCounterToDecrease() {
        XCTAssertEqual(sut.state.counter, 0)
        (1...5).forEach { expected in
            sut.dispatch(CountAction.decrement)
            expect(self.sut.state.counter).to(equal(-expected))
        }
    }
    
    override func setUp() {
        super.setUp()
        sut = Store<CountState>(reducer: Reducers.reduce, state: CountState(counter: 0), middleware: [])
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
