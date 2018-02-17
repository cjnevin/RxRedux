import RxCocoa

extension Store {
    func driver<T: Equatable>(`for` keyPath: KeyPath<StateType, T>) -> Driver<T> {
        return observe(keyPath).asDriver(onErrorDriveWith: .empty())
    }
    
    func driver<T: Equatable>(`for` keyPath: KeyPath<StateType, [T]>) -> Driver<[T]> {
        return observe(keyPath).asDriver(onErrorDriveWith: .empty())
    }
}
