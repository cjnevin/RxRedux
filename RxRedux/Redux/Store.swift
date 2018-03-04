import RxSwift

enum StoreAction: ActionType {
    case initialized
}

final class Store<State: StateType> {
    typealias SideEffectType = SideEffect<Store<State>>
    
    private(set) var state: State
    
    private let stateSubject: BehaviorSubject<State>
    private var sideEffects: [SideEffectType]
    
    init(state: State,
         sideEffects: [SideEffectType] = []) {
        self.state = state
        self.stateSubject = BehaviorSubject(value: state)
        self.sideEffects = sideEffects
        self.dispatch(StoreAction.initialized)
    }
    
    deinit {
        stateSubject.onCompleted()
    }
    
    func dispatch(_ action: ActionType) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.dispatch(action)
            }
            return
        }
        
        precondition(Thread.isMainThread)
        state.reduce(action)
        stateSubject.onNext(state)
        sideEffects.forEach { (sideEffect) in
            sideEffect(self, action)
        }
    }
    
    private func dispatchInternal(_ action: ActionType) {
        state.reduce(action)
        stateSubject.onNext(state)
    }
    
    func register(_ sideEffect: SideEffectType...) {
        precondition(Thread.isMainThread)
        sideEffects.append(contentsOf: sideEffect)
    }
    
    func observe<T: Equatable>(_ keyPath: KeyPath<State, T>) -> Observable<T> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged()
            .share(replay: 1, scope: .whileConnected)
    }
    
    func observe<T: Equatable>(_ keyPath: KeyPath<State, [T]>) -> Observable<[T]> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged(==)
            .share(replay: 1, scope: .whileConnected)
    }
}
