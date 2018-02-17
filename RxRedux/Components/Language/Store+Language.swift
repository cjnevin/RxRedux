import RxSwift

extension Store where StateType == AppState {
    func observeWithLanguageChange<T: Equatable>(_ keyPath: KeyPath<StateType, T>) -> Observable<T> {
        return Observable.combineLatest(
            observe(\AppState.languageState.current),
            observe(keyPath)) { $1 }
    }
    
    func observeWithLanguageChange<T: Equatable>(_ keyPath: KeyPath<StateType, [T]>) -> Observable<[T]> {
        return Observable.combineLatest(
            observe(\AppState.languageState.current),
            observe(keyPath)) { $1 }
    }
}
