import Networking

private extension Networking {
    static let `default` = Networking(baseURL: "")
}

class Api {
    let networking: Networking
    
    init(networking: Networking = .default) {
        self.networking = networking
    }
}
