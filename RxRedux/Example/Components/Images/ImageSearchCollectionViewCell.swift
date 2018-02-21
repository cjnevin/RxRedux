import UIKit

enum ImageSearchCellAccessibility: String {
    case title
    case image
}

class ImageSearchCollectionViewCell: UICollectionViewCell, Identifiable {
    private lazy var imageView = UIImageView.make()
    private var currentPath: String?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(imageView) { make in
            make.edges.equalTo(self)
        }
    }
    
    func setImage(_ image: ImageInfo) {
        currentPath = image.imageUrl
        ImageApi.downloadImage(at: image.imageUrl) { [weak self] (result) in
            if case .success(let image) = result {
                self?.imageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let currentPath = currentPath {
            ImageApi.cancelImageDownload(at: currentPath)
        }
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
