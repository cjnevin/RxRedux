import RxSwift

extension Store where StateType == AppState {
    func localizedObserve() -> Observable<String> {
        return observe(\AppState.languageState.current)
    }
    
    func localizedObserve<T: Equatable>(_ keyPath: KeyPath<StateType, T>) -> Observable<T> {
        return Observable.combineLatest(
            observe(\AppState.languageState.current),
            observe(keyPath)) { $1 }
    }
    
    func localizedObserve<T: Equatable>(_ keyPath: KeyPath<StateType, [T]>) -> Observable<[T]> {
        return Observable.combineLatest(
            observe(\AppState.languageState.current),
            observe(keyPath)) { $1 }
    }
}
