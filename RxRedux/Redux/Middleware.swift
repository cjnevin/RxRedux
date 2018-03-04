import Foundation

typealias Dispatcher = (ActionType) -> Void
typealias DispatchCreator = (@escaping Dispatcher) -> Dispatcher
typealias Middleware<StoreType> = (StoreType) -> (DispatchCreator)

typealias SideEffect<StoreType> = (StoreType, ActionType) -> ()
