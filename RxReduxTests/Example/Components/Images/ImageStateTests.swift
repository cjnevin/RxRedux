import Foundation
import XCTest
import Nimble
import RxNimble
import RxSwift
@testable import RxRedux

extension ImageInfo {
    static func fake() -> ImageInfo {
        return ImageInfo(
            author: "author",
            description: "description",
            title: "title",
            link: "link",
            imageUrl: "imageUrl",
            tags: ["one", "two", "three"],
            datePublished: Date(),
            dateTaken: Date())
    }
}

class ImageStateTests: XCTestCase {
    var subject: PublishSubject<ActionType>!
    var sut: Observable<ImageState>!

    func test_whenLoadingAction_thenExpectEmptyResults() {
        expect(self.sut.map { $0.images }).first.toNot(beEmpty())
        subject.onNext(ImageSearchAction.loading)
        expect(self.sut.map { $0.images }).first.to(beEmpty())
    }

    func test_whenSelectedAction_thenExpectSelectedToNotBeNil() {
        expect(self.sut.map { $0.selected }).first.to(beNil())
        subject.onNext(ImageSearchAction.selected(.fake()))
        expect(self.sut.map {$0.selected }).first.toNot(beNil())
    }

    func test_whenResultsAction_thenExpectResults() {
        expect(self.sut.map { $0.images }).first.toNot(beEmpty())
        expect(self.sut.map { $0.query }).first.to(equal("test"))
        subject.onNext(ImageSearchAction.loaded("testTwo", [.fake(), .fake()]))
        expect(self.sut.map { $0.query }).first.to(equal("testTwo"))
        expect(self.sut.map { $0.images.count }).first.to(equal(2))
    }

    override func setUp() {
        super.setUp()
        subject = PublishSubject<ActionType>()
        sut = ImageState().loop(on: subject, with: [])
        subject.onNext(ImageSearchAction.loaded("test", [.fake()]))
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
