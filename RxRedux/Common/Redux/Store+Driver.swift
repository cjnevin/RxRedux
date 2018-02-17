import RxCocoa

extension Store {
    func observeOnMain<T: Equatable>(_ keyPath: KeyPath<StateType, T>) -> Driver<T> {
        return observe(keyPath).asDriver(onErrorDriveWith: .empty())
    }
    
    func observeOnMain<T: Equatable>(_ keyPath: KeyPath<StateType, [T]>) -> Driver<[T]> {
        return observe(keyPath).asDriver(onErrorDriveWith: .empty())
    }
}
