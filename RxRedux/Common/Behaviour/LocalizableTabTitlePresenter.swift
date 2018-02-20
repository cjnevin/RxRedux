import RxSwift

class LocalizableTabTitlePresenter<T: TabTitlableView>: Presenter<T> {
    private let localizationKey: String
    
    init(localizationKey: String) {
        self.localizationKey = localizationKey
    }
    
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(
            store.uniquelyObserve(\.languageState.current)
                .map { [weak self] _ in self?.localizationKey.localized() ?? "" }
                .subscribe(onNext: view.setTabTitle)
        )
    }
}

