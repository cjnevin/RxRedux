import Foundation

class TabbablePresenter<T: TabbableView>: Presenter<T> {
    private let localizationKey: String
    
    init(localizationKey: String) {
        self.localizationKey = localizationKey
    }
    
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(
            store.observe(\.languageState.current)
                .map { [weak self] _ in self?.localizationKey.localized() ?? "" }
                .debug()
                .subscribe(onNext: view.setTabTitle)
        )
    }
}

