import UIKit
import SnapKit

extension UIView {
    func addSubview(_ child: UIView, constraints: (ConstraintMaker) -> ()) {
        addSubview(child)
        child.snp.makeConstraints(constraints)
    }
}
