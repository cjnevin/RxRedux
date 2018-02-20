import Malibu

struct Api {
    let images: Networking<ImageRequest>
    
    init(images: Networking<ImageRequest>) {
        self.images = images
    }
}
