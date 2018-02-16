import Foundation

typealias Reducer<StateType> = (_ state: StateType, _ action: ActionType) -> StateType
