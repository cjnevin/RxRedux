import RxSwift

extension Store where StateType == AppState {
    func localizedObserve() -> Observable<String> {
        return uniquelyObserve(\AppState.languageState.current)
    }
    
    func localizedObserve<T: Equatable>(_ keyPath: KeyPath<StateType, T>) -> Observable<T> {
        return Observable.combineLatest(
            uniquelyObserve(\AppState.languageState.current),
            uniquelyObserve(keyPath)) { $1 }
    }
    
    func localizedObserve<T: Equatable>(_ keyPath: KeyPath<StateType, [T]>) -> Observable<[T]> {
        return Observable.combineLatest(
            uniquelyObserve(\AppState.languageState.current),
            uniquelyObserve(keyPath)) { $1 }
    }
}
