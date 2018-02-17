import Foundation
import Action
import RxSwift

class LanguagePresenter<T: LanguageView>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(Observable
            .combineLatest(store.observe(\.languageState.current),
                           store.observe(\.languageState.list))
            .map { current, list in
                list.map { LanguageCellViewModel(language: $0, isSelected: current == $0) }
            }
            .subscribe(onNext: view.setLanguages))
        
        disposeOnViewDetach(view.selectedLanguage.subscribe(onNext: { (viewModel) in
            store.dispatch(LanguageAction.set(viewModel.language))
        }))
        
        store.dispatch(LanguageAction.getList())
    }
}

protocol LanguageView: TitlableView, TabbableView {
    var selectedLanguage: PublishSubject<LanguageCellViewModel> { get }
    func setLanguages(_ languages: [LanguageCellViewModel])
}

struct LanguageCellViewModel {
    let language: String
    let isSelected: Bool
}
