import Foundation

typealias SideEffect<State: StateType> = (State, ActionType) -> ()
