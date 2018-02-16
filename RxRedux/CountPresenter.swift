import Foundation
import Action
import RxSwift

class CountPresenter<T: CountView>: Presenter<T> {
    private func format(_ count: Int) -> String {
        return "Count is now: \(count)"
    }
    
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(
            store.observe(\.countState.counter).map(format).subscribe(onNext: view.setCountText)
        )
        
        let decrement = CocoaAction() { .just(store.dispatch(CountAction.decrement)) }
        let increment = CocoaAction() { .just(store.dispatch(CountAction.increment)) }
        
        view.setDecrementAction(decrement)
        view.setIncrementAction(increment)
    }
}

protocol CountView {
    func setCountText(_ text: String)
    func setDecrementAction(_ action: CocoaAction)
    func setIncrementAction(_ action: CocoaAction)
}
