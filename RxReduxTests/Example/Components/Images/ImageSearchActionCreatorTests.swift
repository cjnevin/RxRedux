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
        let routingMiddleware = RoutingMiddleware<AppState, Store<AppState>>(routers: [imageRouterMock])
        
        store.register(routingMiddleware.create())
        store.dispatch(ImageSearchAction.selectImage(.fake()))
        expect(store.state.imageState.selected).toNot(beNil())
        imageRouterMock.handleMock.expect(count: .toBeOne)
        guard case ImageSearchRoute.showImage = imageRouterMock.handleSpy.get()! else {
            XCTFail()
            return
        }
    }
}
