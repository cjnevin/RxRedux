import Foundation
import Action
import RxSwift

class StylePresenter<T: StyleView>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(Observable
            .combineLatest(store.observe(\.styleState.current),
                           store.localizedObserve(\.styleState.list))
            .map { (args) -> [StyleCellViewModel] in
                args.1.map { style in
                    StyleCellViewModel(style: style, isSelected: style == args.0)
                }
            }
            .subscribe(onNext: view.setStyles))
        
        disposeOnViewDetach(view.selectedStyle.subscribe(onNext: { (viewModel) in
            store.dispatch(StyleAction.set(viewModel.style))
        }))
        
        store.dispatch(StyleAction.getList())
    }
}

protocol StyleView: TitlableView, TabTitlableView {
    var selectedStyle: PublishSubject<StyleCellViewModel> { get }
    func setStyles(_ styles: [StyleCellViewModel])
}

struct StyleCellViewModel {
    let style: Style
    let isSelected: Bool
}

