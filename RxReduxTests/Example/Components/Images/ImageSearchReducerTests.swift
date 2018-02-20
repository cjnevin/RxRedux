import Foundation
import Nimble
import XCTest
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

class ImageSearchReducerTests: XCTestCase {
    var sut: Store<ImageState>!

    func test_whenLoadingAction_thenExpectEmptyResults() {
        expect(self.sut.state.results).toNot(beEmpty())
        sut.dispatch(ImageSearchAction.loading)
        expect(self.sut.state.results).to(beEmpty())
    }

    func test_whenSelectedAction_thenExpectSelectedToNotBeNil() {
        expect(self.sut.state.selected).to(beNil())
        sut.dispatch(ImageSearchAction.selected(.fake()))
        expect(self.sut.state.selected).toNot(beNil())
    }

    func test_whenResultsAction_thenExpectResults() {
        expect(self.sut.state.results).toNot(beEmpty())
        sut.dispatch(ImageSearchAction.loaded([.fake(), .fake()]))
        expect(self.sut.state.results.count).to(be(2))
    }

    override func setUp() {
        super.setUp()
        sut = Store<ImageState>(reducer: Reducers.reduce, state: ImageState(results: [.fake()], selected: nil))
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
