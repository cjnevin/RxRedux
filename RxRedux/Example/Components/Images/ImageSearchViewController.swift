import UIKit
import SnapKit
import RxSwift

enum ImageSearchViewAccessibility: String {
    case collectionView
    case searchBar
    case loading
}

class ImageSearchViewController: UIViewController, Searchable {
    fileprivate lazy var collectionView = UICollectionView.make()
    fileprivate lazy var loadingView = LoadingView(ImageSearchViewAccessibility.loading)
    
    private let dataSource = ImageSearchCollectionViewDataSource()
    
    var selectedImage = PublishSubject<ImageInfo>()
    var searchText = PublishSubject<String>()
    var presenter: ImageSearchPresenter<ImageSearchViewController>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.collectionView = collectionView
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        render()
        presenter?.attachView(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissSearch()
    }
    
    func dismissSearch() {
        navigationItem.searchController?.dismiss(animated: false, completion: nil)
    }
    
    deinit {
        presenter?.detachView()
    }
    
    private func render() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView) { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(loadingView) { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
}

extension ImageSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageInfo = dataSource.images[indexPath.row]
        selectedImage.onNext(imageInfo)
    }
}

extension ImageSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText.onNext(searchController.searchBar.text ?? "")
    }
}

extension ImageSearchViewController: SearchView {
    func setImages(_ images: [ImageInfo]) {
        dataSource.images = images
    }
    
    func setInitialSearchText(_ searchText: String) {
        navigationItem.searchController?.searchBar.text = searchText
    }
    
    func setPlaceholderText(_ text: String) {
        navigationItem.searchController?.searchBar.placeholder = text
    }
    
    func showLoadingIndicator() {
        loadingView.isHidden = false
    }
    
    func hideLoadingIndicator() {
        loadingView.isHidden = true
    }
}

extension UICollectionView {
    static func make() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width: screenWidth / 2,
                                 height: screenWidth / 3)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.accessibilityIdentifier = ImageSearchViewAccessibility.collectionView.rawValue
        return collectionView
    }
}
