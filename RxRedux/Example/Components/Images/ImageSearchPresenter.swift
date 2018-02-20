import Foundation
import Action
import RxSwift

class ImageSearchPresenter<T: SearchView>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        let isLoadingSubject = PublishSubject<Bool>()
        
        disposeOnViewDetach(isLoadingSubject
            .filter({ $0 })
            .subscribe(onNext: { _ in
                view.showLoadingIndicator()
            }))
        
        disposeOnViewDetach(isLoadingSubject
            .debounce(0.5, scheduler: ConcurrentMainScheduler.instance)
            .filter({ !$0 })
            .subscribe(onNext: { _ in
                view.hideLoadingIndicator()
            }))
        
        disposeOnViewDetach(store
            .uniquelyObserve(\.languageState.current)
            .subscribe(onNext: { _ in
                view.setPlaceholderText(SearchText.placeholder)
            }))
        
        disposeOnViewDetach(view.selectedImage
            .subscribe(onNext: { (imageInfo) in
                store.dispatch(ImageSearchAction.selectImage(imageInfo))
            }))
        
        disposeOnViewDetach(view.searchText
            .startWith("")
            .debounce(0.5, scheduler: ConcurrentMainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { (text) in
                isLoadingSubject.onNext(true)
                store.dispatch(ImageSearchAction.search(for: text))
            }))
        
        disposeOnViewDetach(store.observe(\AppState.imageState.results)
            .subscribe(onNext: { (results) in
                view.setImages(results)
                isLoadingSubject.onNext(false)
            }))
    }
}

protocol SearchView: TabTitlableView, TitlableView, LoadIndicatingView {
    var searchText: PublishSubject<String> { get }
    var selectedImage: PublishSubject<ImageInfo> { get }
    func setImages(_ images: [ImageInfo])
    func setPlaceholderText(_ text: String)
}

private enum SearchText {
    static var placeholder: String { return "image.search.placeholder".localized() }
}
