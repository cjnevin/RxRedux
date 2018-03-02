import RxSwift

extension ObservableType where E == AppState {
    func localized() -> Observable<Void> {
        return listen(\.languageState.current)
            .map { _ in () }
    }

    func localizedListen<T: Equatable>(_ keyPath: KeyPath<E, T>) -> Observable<T> {
        return Observable.combineLatest(localized(), listen(keyPath)) { $1 }
    }

    func localizedListen<T: Equatable>(_ keyPath: KeyPath<E, [T]>) -> Observable<[T]> {
        return Observable.combineLatest(localized(), listen(keyPath)) { $1 }
    }
}
