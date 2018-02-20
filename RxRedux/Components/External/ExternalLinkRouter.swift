import UIKit

enum ExternalRoute: RouteAction {
    case openLink(String)
}

class ExternalLinkRouter: Router {
    func handle(route: RouteAction) -> Bool {
        switch route {
        case ExternalRoute.openLink(let link):
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
            return true
        default: return false
        }
    }
}
