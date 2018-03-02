import Foundation
import XCTest
import Nimble
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
    var sut: ImageState!

    func test_whenLoadingAction_thenExpectEmptyResults() {
        expect(self.sut.images).toNot(beEmpty())
        sut.reduce(ImageSearchAction.loading)
        expect(self.sut.images).to(beEmpty())
    }

    func test_whenSelectedAction_thenExpectSelectedToNotBeNil() {
        expect(self.sut.selected).to(beNil())
        sut.reduce(ImageSearchAction.selected(.fake()))
        expect(self.sut.selected).toNot(beNil())
    }

    func test_whenResultsAction_thenExpectResults() {
        expect(self.sut.images).toNot(beEmpty())
        expect(self.sut.query).to(equal("test"))
        sut.reduce(ImageSearchAction.loaded("testTwo", [.fake(), .fake()]))
        expect(self.sut.query).to(equal("testTwo"))
        expect(self.sut.images.count).to(equal(2))
    }

    override func setUp() {
        super.setUp()
        sut = ImageState(isLoading: false, images: [.fake()], errorMessage: nil, selected: nil, query: "test")
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
