import UIKit
import RxCocoa
import RxSwift
import Action

extension UINavigationItem: NavigationItemComponent {
    func setTextValue(_ textValue: String?) {
        title = textValue
    }
}

extension UITabBarItem: TabBarItemComponent {
    func setTextValue(_ textValue: String?) {
        title = textValue
    }
    
    func setIcon(_ tabIcon: TabIcon) {
        image = tabIcon.image
        selectedImage = tabIcon.selectedImage
    }
}

extension UITextField: TextFieldComponent {
    var textValue: Observable<String?> {
        return rx.text.asObservable()
    }
    
    var beganEditing: Observable<Void> {
        return rx.controlEvent(.editingDidBegin).asObservable()
    }
    
    var endedEditing: Observable<Void> {
        return rx.controlEvent(.editingDidEndOnExit).asObservable()
    }
    
    func setTextValue(_ textValue: String?) {
        text = textValue
    }
    
    func setPlaceholderText(_ text: String?) {
        placeholder = text
    }
    
    func setActive(_ isActive: Bool) {
        if isActive {
            becomeFirstResponder()
        } else {
            resignFirstResponder()
        }
    }
}

extension EmailTextFieldComponent where Self: UITextField {
    func applyEmailConfiguration() {
        keyboardType = .emailAddress
        returnKeyType = .next
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}

extension PasswordTextFieldComponent where Self: UITextField {
    func applyPasswordConfiguration() {
        isSecureTextEntry = true
        keyboardType = .default
        returnKeyType = .send
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}

extension UILabel: LabelComponent {
    func setTextValue(_ textValue: String?) {
        text = textValue
    }
}

extension UIButton: ButtonComponent {
    func setAction(_ action: CocoaAction?) {
        var me = self
        me.rx.action = action
    }
    
    func setTextValue(_ textValue: String?) {
        setTitle(textValue, for: .normal)
    }
}

extension UISegmentedControl: SegmentComponent {
    var selectedIndex: Observable<Int> {
        return rx.controlEvent(.valueChanged)
            .map { [unowned self] in
                self.selectedSegmentIndex
        }
    }
    
    func setItems(_ items: [String]) {
        removeAllSegments()
        items.enumerated().forEach { index, item in
            insertSegment(withTitle: item, at: index, animated: false)
        }
    }
    
    func setSelectedIndex(_ selected: Int) {
        selectedSegmentIndex = selected
    }
}
