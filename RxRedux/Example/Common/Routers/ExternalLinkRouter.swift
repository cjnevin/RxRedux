import UIKit

enum ExternalRoute: RouteAction {
    case openLink(String)
}

class ExternalLinkRouter: Router {
    func handle(_ route: RouteAction) -> Bool {
        guard case ExternalRoute.openLink(let link) = route, let url = URL(string: link) else {
            return false
        }
        UIApplication.shared.open(url)
        return true
    }
}
