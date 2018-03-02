import Foundation
import Action
import RxSwift

class LanguagePresenter<T: LanguageView>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)

        disposeOnViewDetach(state.listen(\.languageState)
            .map { state in
                state.list.map { LanguageCellViewModel(language: $0, isSelected: $0 == state.current) }
            }
            .subscribe(onNext: view.setLanguages))
        
        disposeOnViewDetach(view.selectedLanguage.subscribe(onNext: { (viewModel) in
            fire.onNext(LanguageAction.changeTo(viewModel.language))
        }))
        
        fire.onNext(LanguageAction.getList())
    }
}

protocol LanguageView: TitlableView, TabTitlableView {
    var selectedLanguage: PublishSubject<LanguageCellViewModel> { get }
    func setLanguages(_ languages: [LanguageCellViewModel])
}

struct LanguageCellViewModel {
    let language: String
    let isSelected: Bool
}
