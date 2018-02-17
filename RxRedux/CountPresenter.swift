import Foundation
import Action
import RxSwift

enum CountViewText {
    static let decrement = "count.decrement".localized()
    static let increment = "count.increment".localized()
    static let value = "count.value".localizedWithInt
}

class CountPresenter<T: CountView>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(
            store.observe(\.countState.counter)
                .map(CountViewText.value)
                .subscribe(onNext: view.setCountText))
        
        view.setDecrementText(CountViewText.decrement, action: CocoaAction(CountAction.decrement))
        view.setIncrementText(CountViewText.increment, action: CocoaAction(CountAction.increment))
    }
}

protocol CountView {
    func setCountText(_ text: String)
    func setDecrementText(_ text: String, action: CocoaAction)
    func setIncrementText(_ text: String, action: CocoaAction)
}
