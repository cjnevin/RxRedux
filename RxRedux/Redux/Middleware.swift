import Foundation

typealias Dispatcher = (ActionType) -> Void
typealias DispatchCreator = (@escaping Dispatcher) -> Dispatcher
typealias Middleware<State: StateType> = (State) -> (DispatchCreator)
