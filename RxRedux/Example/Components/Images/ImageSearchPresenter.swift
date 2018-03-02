import Foundation
import Action
import RxSwift

class ImageSearchPresenter<T: SearchView>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(state.listen(\.imageState.isLoading)
            .filter({ $0 })
            .subscribe(onNext: { _ in
                view.showLoadingIndicator()
            }))
        
        disposeOnViewDetach(state.listen(\.imageState.isLoading)
            .debounce(0.5, scheduler: ConcurrentMainScheduler.instance)
            .filter({ !$0 })
            .subscribe(onNext: { _ in
                view.hideLoadingIndicator()
            }))
        
        disposeOnViewDetach(state.listen(\.languageState.current)
            .subscribe(onNext: { _ in
                view.setPlaceholderText(SearchText.placeholder)
            }))
        
        disposeOnViewDetach(view.selectedImage
            .subscribe(onNext: { (imageInfo) in
                fire.onNext(ImageSearchAction.selectImage(imageInfo))
            }))
        
        disposeOnViewDetach(view.searchText
            .debounce(0.5, scheduler: ConcurrentMainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { (text) in
                fire.onNext(ImageSearchAction.search(for: text))
            }))
        
        disposeOnViewDetach(state.listen(\.imageState.query)
            .take(1)
            .subscribe(onNext: { (query) in
                view.setInitialSearchText(query)
            }))
        
        disposeOnViewDetach(state.listen(\.imageState.images)
            .subscribe(onNext: { (images) in
                view.setImages(images)
            }))
    }
}

protocol SearchView: TabTitlableView, TitlableView, LoadIndicatingView {
    var searchText: PublishSubject<String> { get }
    var selectedImage: PublishSubject<ImageInfo> { get }
    func setInitialSearchText(_ searchText: String)
    func setImages(_ images: [ImageInfo])
    func setPlaceholderText(_ text: String)
}

private enum SearchText {
    static var placeholder: String { return "image.search.placeholder".localized() }
}
