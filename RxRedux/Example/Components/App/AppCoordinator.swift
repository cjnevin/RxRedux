import Foundation

// Note: In an ideal world we would track the route that the user has taken as well
//       so we can restore it when the user comes back from a hard launch
//       but since this is just an example app it seems like overkill.

protocol RouteAction: ActionType { }

protocol Router {
    func handle(_ route: RouteAction) -> Bool
}

class AppCoordinator {
    private var routers: [Router]
    
    init(routers: [Router] = []) {
        self.routers = routers
    }
    
    func register(router: Router) {
        self.routers.append(router)
    }

    func sideEffect(_ state: AppState, _ action: ActionType) {
        guard let routeAction = action as? RouteAction else {
            return
        }

        DispatchQueue.main.async {
            assert(nil != self.routers.first(where: { (router) -> Bool in
                router.handle(routeAction)
            }))
        }
    }
}
