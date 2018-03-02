import RxSwift

class LocalizableTitlePresenter<T: TitlableView>: Presenter<T> {
    private let localizationKey: String
    
    init(localizationKey: String) {
        self.localizationKey = localizationKey
    }
    
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(
            state.listen(\.languageState.current)
                .map { [weak self] _ in self?.localizationKey.localized() ?? "" }
                .subscribe(onNext: view.setTitle)
        )
    }
}
