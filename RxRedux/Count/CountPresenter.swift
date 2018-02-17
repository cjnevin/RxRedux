import Foundation
import Action
import RxSwift

class CountPresenter<T: CountView>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(
            store.observeOnMain(\.countState.counter)
                .map(CountText.value)
                .drive(onNext: view.setCountText))
        
        view.setDecrementText(CountText.decrement, action: CocoaAction(CountAction.decrement))
        view.setIncrementText(CountText.increment, action: CocoaAction(CountAction.increment))
    }
}

protocol CountView {
    func setCountText(_ text: String)
    func setDecrementText(_ text: String, action: CocoaAction)
    func setIncrementText(_ text: String, action: CocoaAction)
}

private enum CountText {
    static let decrement = "count.decrement".localized()
    static let increment = "count.increment".localized()
    static let value = "count.value".localizedWithInt
}
