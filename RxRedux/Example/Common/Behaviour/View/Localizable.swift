import RxSwift

protocol Localizable { }

extension Localizable {
    func subscribe(`for` localizationKey: String, block: @escaping (String) -> ()) -> Disposable {
        return store.localizedObserve()
            .map { _ in localizationKey.localized() }
            .subscribe(onNext: block)
    }
}
