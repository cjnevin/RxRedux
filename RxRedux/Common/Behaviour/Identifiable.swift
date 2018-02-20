import UIKit

protocol Identifiable: class {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func register(_ cellClass: Identifiable.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: Identifiable>(at indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}

extension UITableView {
    func register(_ cellClass: Identifiable.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: Identifiable>(at indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}


