import RxSwift

extension ObservableType {
    func listen<T: Equatable>(_ keyPath: KeyPath<E, T>) -> Observable<T> {
        return map { $0[keyPath: keyPath] }.distinctUntilChanged()
    }

    func listen<T: Equatable>(_ keyPath: KeyPath<E, [T]>) -> Observable<[T]> {
        return map { $0[keyPath: keyPath] }.distinctUntilChanged(==)
    }
}
