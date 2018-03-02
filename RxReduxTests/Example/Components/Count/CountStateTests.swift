import Foundation
import Nimble
import RxSwift
import RxNimble
import XCTest
@testable import RxRedux

class CountStateTests: XCTestCase {
    var subject: PublishSubject<ActionType>!
    var sut: Observable<CountState>!
    
    func test_whenIncrementAction_thenExpectCounterToIncrease() {
        expect(self.sut.map { $0.counter }).first == 0
        (1...5).forEach { expected in
            subject.onNext(CountAction.increment)
            expect(self.sut.map { $0.counter }).first == expected
        }
    }
    
    func test_whenDecrementAction_thenExpectCounterToDecrease() {
        expect(self.sut.map { $0.counter }).first == 0
        (1...5).forEach { expected in
            subject.onNext(CountAction.decrement)
            expect(self.sut.map { $0.counter }).first == -expected
        }
    }
    
    override func setUp() {
        super.setUp()
        subject = PublishSubject<ActionType>()
        sut = CountState(counter: 0).loop(on: subject, with: [])
    }
    
    override func tearDown() {
        super.tearDown()
        subject = nil
        sut = nil
    }
}
