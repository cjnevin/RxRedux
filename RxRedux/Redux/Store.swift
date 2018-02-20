import RxSwift

final class Store<StateType> {
    typealias MiddlewareType = Middleware<Store<StateType>>
    
    private(set) var state: StateType
    
    private let reducer: Reducer<StateType>
    private let stateSubject: BehaviorSubject<StateType>
    private var middlewares: [MiddlewareType]
    
    init(reducer: @escaping Reducer<StateType>, state: StateType, middlewares: [MiddlewareType] = []) {
        self.reducer = reducer
        self.state = state
        self.stateSubject = BehaviorSubject(value: state)
        self.middlewares = middlewares
    }
    
    deinit {
        stateSubject.onCompleted()
    }
    
    func dispatch(_ action: ActionType) {
        precondition(Thread.isMainThread)
        middlewares.reduce(dispatchInternal, { dispatch, middleware in
            middleware(self)(dispatch)
        })(action)
    }
    
    private func dispatchInternal(_ action: ActionType) {
        state = reducer(state, action)
        stateSubject.onNext(state)
    }
    
    func register(_ middleware: MiddlewareType...) {
        precondition(Thread.isMainThread)
        middlewares.append(contentsOf: middleware)
    }
    
    func observe<T>(_ keyPath: KeyPath<StateType, T>) -> Observable<T> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .share(replay: 1, scope: .whileConnected)
    }
    
    func observe<T>(_ keyPath: KeyPath<StateType, [T]>) -> Observable<[T]> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .share(replay: 1, scope: .whileConnected)
    }
    
    func uniquelyObserve<T: Equatable>(_ keyPath: KeyPath<StateType, T>) -> Observable<T> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged()
            .share(replay: 1, scope: .whileConnected)
    }
    
    func uniquelyObserve<T: Equatable>(_ keyPath: KeyPath<StateType, [T]>) -> Observable<[T]> {
        return stateSubject
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged(==)
            .share(replay: 1, scope: .whileConnected)
    }
}
