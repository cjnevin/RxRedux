import RxSwift

final class Store<State: StateType> {
    typealias MiddlewareType = Middleware<State>
    
    private var state: State
    private let stateSubject: BehaviorSubject<State>
    
    private var middlewares: [MiddlewareType]
    
    init(state: State, middlewares: [MiddlewareType] = []) {
        self.state = state
        self.stateSubject = BehaviorSubject(value: state)
        self.middlewares = middlewares
    }
    
    deinit {
        stateSubject.onCompleted()
    }
    
    private func _dispatch(_ action: ActionType) {
        state.reduce(action)
        stateSubject.onNext(state)
    }
    
    func dispatch(_ action: ActionType) {
        precondition(Thread.isMainThread)
        middlewares.reduce(_dispatch, { dispatch, middleware in
            middleware(state)(dispatch)
        })(action)
    }
    
    func register(_ middleware: MiddlewareType...) {
        precondition(Thread.isMainThread)
        middlewares.append(contentsOf: middleware)
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
