import RxSwift

enum StoreAction: ActionType {
    case initialized
}

final class Store<State: StateType> {
    typealias MiddlewareType = Middleware<Store<State>>
    
    private(set) var state: State
    
    private let stateSubject: BehaviorSubject<State>
    private var middlewares: [MiddlewareType]
    
    init(state: State, middlewares: [MiddlewareType] = []) {
        self.state = state
        self.stateSubject = BehaviorSubject(value: state)
        self.middlewares = middlewares
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
        middlewares.reduce(dispatchInternal, { dispatch, middleware in
            middleware(self)(dispatch)
        })(action)
    }
    
    private func dispatchInternal(_ action: ActionType) {
        state.reduce(action)
        stateSubject.onNext(state)
    }
    
    func register(_ middleware: MiddlewareType...) {
        precondition(Thread.isMainThread)
        middlewares.append(contentsOf: middleware)
    }
    
    func observe<T>(_ keyPath: KeyPath<State, T>) -> Observable<T> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .share(replay: 1, scope: .whileConnected)
    }
    
    func observe<T>(_ keyPath: KeyPath<State, [T]>) -> Observable<[T]> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .share(replay: 1, scope: .whileConnected)
    }
    
    func uniquelyObserve<T: Equatable>(_ keyPath: KeyPath<State, T>) -> Observable<T> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged()
            .share(replay: 1, scope: .whileConnected)
    }
    
    func uniquelyObserve<T: Equatable>(_ keyPath: KeyPath<State, [T]>) -> Observable<[T]> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged(==)
            .share(replay: 1, scope: .whileConnected)
    }
}
