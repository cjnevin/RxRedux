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

class ImageStateTests: XCTestCase {
    var sut: Store<ImageState>!

    func test_whenLoadingAction_thenExpectEmptyResults() {
        expect(self.sut.state.images).toNot(beEmpty())
        sut.dispatch(ImageSearchAction.loading)
        expect(self.sut.state.images).to(beEmpty())
    }

    func test_whenSelectedAction_thenExpectSelectedToNotBeNil() {
        expect(self.sut.state.selected).to(beNil())
        sut.dispatch(ImageSearchAction.selected(.fake()))
        expect(self.sut.state.selected).toNot(beNil())
    }

    func test_whenResultsAction_thenExpectResults() {
        expect(self.sut.state.images).toNot(beEmpty())
        sut.dispatch(ImageSearchAction.loaded([.fake(), .fake()]))
        expect(self.sut.state.images.count).to(be(2))
    }

    override func setUp() {
        super.setUp()
        sut = Store<ImageState>(state: ImageState(images: [.fake()], imagesError: nil, selected: nil))
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
