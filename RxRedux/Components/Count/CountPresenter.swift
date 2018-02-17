import Foundation
import Action
import RxSwift

class CountPresenter<T: CountView>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(
            store.observe(\.languageState.current)
                .subscribe(onNext: { (language) in
                    view.setDecrementText(CountText.decrement)
                    view.setIncrementText(CountText.increment)
                }))
        
        disposeOnViewDetach(Observable
            .combineLatest(store.observe(\.languageState.current),
                           store.observe(\.countState.counter)) { CountText.value($1) }
                .subscribe(onNext: view.setCountText))
        
        view.setDecrementAction(CocoaAction(CountAction.decrement))
        view.setIncrementAction(CocoaAction(CountAction.increment))
    }
}

protocol CountView: TitlableView, TabbableView {
    func setCountText(_ text: String)
    func setDecrementText(_ text: String)
    func setDecrementAction(_ action: CocoaAction)
    func setIncrementText(_ text: String)
    func setIncrementAction(_ action: CocoaAction)
}

private enum CountText {
    static var title: String { return "count.title".localized() }
    static var decrement: String { return "count.decrement".localized() }
    static var increment: String { return "count.increment".localized() }
    static let value: (Int) -> (String) = "count.value".localizedWithParameter
}
