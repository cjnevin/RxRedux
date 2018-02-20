import Malibu

var api: Api = Api(images: .init())

struct Api {
    let images: Networking<ImageRequest>
    
    init(images: Networking<ImageRequest>) {
        self.images = images
    }
}
