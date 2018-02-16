import RxSwift

final class Store<StateType> {
    private(set) var state: StateType
    
    private let reducer: Reducer<StateType>
    private let stateSubject: BehaviorSubject<StateType>
    private let middleware: [Middleware<Store<StateType>>]
    
    init(reducer: @escaping Reducer<StateType>, state: StateType, middleware: [Middleware<Store<StateType>>]) {
        self.reducer = reducer
        self.state = state
        self.stateSubject = BehaviorSubject(value: state)
        self.middleware = middleware
    }
    
    deinit {
        stateSubject.onCompleted()
    }
    
    func dispatch(_ action: ActionType) {
        assert(Thread.isMainThread)
        middleware.reduce(dispatchInternal, { dispatch, middlewareInstance in
            middlewareInstance(self)(dispatch)
        })(action)
    }
    
    private func dispatchInternal(_ action: ActionType) {
        state = reducer(state, action)
        stateSubject.onNext(state)
    }
    
    func observe<T: Equatable>(_ keyPath: KeyPath<StateType, T>) -> Observable<T> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged()
    }
    
    func observe<T: Equatable>(_ keyPath: KeyPath<StateType, [T]>) -> Observable<[T]> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged(==)
    }
}
