import Foundation
import Nimble
import XCTest
import Networking
@testable import RxRedux

class ImageRouterMock: Router {
    let handleSpy = Spy<RouteAction>()
    let handleMock = Mock<Bool>(true)
    func handle(route: RouteAction) -> Bool {
        handleSpy.set(route)
        return handleMock.execute()
    }
}

class ImageSearchActionCreatorTests: ReduxTestCase {
    func test_whenSelectImageAction_thenExpectRouteAndSelectedActions() {
        let imageRouterMock = ImageRouterMock()
        let coordinator = Coordinator<AppState, Store<AppState>>(routers: [imageRouterMock])
        
        store.register(coordinator.sideEffect)
        store.dispatch(ImageSearchAction.selectImage(.fake()))
        expect(store.state.imageState.selected).toNot(beNil())
        imageRouterMock.handleMock.expect(count: .toBeOne)
        guard case ImageSearchRoute.showImage = imageRouterMock.handleSpy.get()! else {
            XCTFail()
            return
        }
    }
    
    func test_whenSearchActionWithNoQuery_thenExpectError() {
        store.register(Logger().sideEffect)
        expect(store.state.imageState.errorMessage).to(beNil())
        api.networking.fakeGET("https://api.flickr.com/services/feeds/photos_public.gne", response: nil, statusCode: 500)
        store.dispatch(ImageSearchAction.search(for: ""))
        waitUntil(timeout: 0.1) { (completion) in
            expect(store.state.imageState.errorMessage).toNot(beNil())
            completion()
        }
    }
}
