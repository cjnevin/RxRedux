import UIKit
import RxSwift

protocol LocalizablePlaceholder: Localizable {
    func setPlaceholder(_ localizationKey: String) -> Disposable
}

extension LocalizablePlaceholder where Self: UITextField {
    func setPlaceholder(_ localizationKey: String) -> Disposable {
        return subscribe(for: localizationKey) { [weak self] (title) in
            self?.placeholder = title
        }
    }
}
