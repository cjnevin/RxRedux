import UIKit
import When

enum ImageSearchCellAccessibility: String {
    case title
    case image
}

class ImageSearchCollectionViewCell: UICollectionViewCell, Identifiable {
    private lazy var imageView = UIImageView.make()
    private var currentRequest: Promise<UIImage>?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(imageView) { make in
            make.edges.equalTo(self)
        }
    }
    
    func setImage(_ image: ImageInfo) {
        currentRequest = ImageSearchAPI.downloadImage(image)
        currentRequest?.done({ [weak self] (image) in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentRequest?.cancel()
        imageView.image = nil
    }
}

private extension UIImageView {
    static func make() -> UIImageView {
        let imageView: UIImageView = UIImageView(ImageSearchCellAccessibility.image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
