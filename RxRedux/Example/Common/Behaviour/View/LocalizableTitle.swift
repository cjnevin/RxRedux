import Foundation
import RxSwift

extension UITabBarItem: LocalizableTitle { }

protocol LocalizableTitle: Localizable {
    func setTitle(_ localizedKey: String) -> Disposable
}

extension LocalizableTitle where Self: UIViewController {
    func setTitle(_ localizationKey: String) -> Disposable {
        return subscribe(for: localizationKey) { [weak self] title in
            self?.navigationItem.title = title
        }
    }
}

extension LocalizableTitle where Self: UILabel {
    func setTitle(_ localizationKey: String) -> Disposable {
        return subscribe(for: localizationKey) { [weak self] title in
            self?.text = title
        }
    }
}

extension LocalizableTitle where Self: UIButton {
    func setTitle(_ localizationKey: String) -> Disposable {
        return subscribe(for: localizationKey) { [weak self] title in
            self?.setTitle(title, for: .normal)
        }
    }
}

extension LocalizableTitle where Self: UITabBarItem {
    func setTitle(_ localizationKey: String) -> Disposable {
        return subscribe(for: localizationKey) { [weak self] title in
            self?.title = title
        }
    }
}

