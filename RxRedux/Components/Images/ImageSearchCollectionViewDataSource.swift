import UIKit

class ImageSearchCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.register(ImageSearchCollectionViewCell.self)
        }
    }
    
    var images: [ImageInfo] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageSearchCollectionViewCell = collectionView.dequeueReusableCell(at: indexPath)
        cell.setImage(images[indexPath.row])
        return cell
    }
}
