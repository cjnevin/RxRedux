import Foundation

enum Progress<T> {
    case loading
    case complete(T)
}
