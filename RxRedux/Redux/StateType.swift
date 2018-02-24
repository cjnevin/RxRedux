import Foundation

protocol StateType {
    mutating func reduce(_ action: ActionType)
}
