import Foundation
import Nimble
import XCTest
import Networking
@testable import RxRedux

class ImageRouterMock: Router {
    let handleSpy = Spy<RouteAction>()
    let handleMock = Mock<Bool>(true)
    func handle(_ route: RouteAction) -> Bool {
        handleSpy.set(route)
        return handleMock.execute()
    }
}

/*
class ImageSearchActionCreatorTests: ReduxTestCase {
    override func setUp() {
        super.setUp()
        prepareMockState()
    }

    func test_whenSelectImageAction_thenExpectRouteAndSelectedActions() {
        let imageRouterMock = ImageRouterMock()
        let coordinator = AppCoordinator(routers: [imageRouterMock])
        prepareMockState(coordinator: coordinator)
        fire.onNext(ImageSearchAction.selectImage(.fake()))
        expect(state.map { $0.imageState.selected }).first.toNot(beNil())
        imageRouterMock.handleMock.expect(count: .toBeOne)
        guard case ImageSearchRoute.showImage = imageRouterMock.handleSpy.get()! else {
            XCTFail()
            return
        }
    }
    
    func test_whenSearchActionWithNoQuery_thenExpectError() {
        prepareMockState(hasActionLogger: true)
        expect(state.map { $0.imageState.errorMessage }).first.to(beNil())
        api.networking.fakeGET("https://api.flickr.com/services/feeds/photos_public.gne", response: nil, statusCode: 500)
        fire.onNext(ImageSearchAction.search(for: ""))
        waitUntil(timeout: 0.1) { (completion) in
            expect(state.map { $0.imageState.errorMessage }).first.toNot(beNil())
            completion()
        }
    }
}
*/

