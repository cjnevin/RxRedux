import Action
import RxSwift

protocol ActionSettableComponent {
    func setAction(_ action: CocoaAction?)
}

protocol TextValueSettableComponent {
    func setTextValue(_ textValue: String?)
}

protocol IndexSettableComponent {
    func setSelectedIndex(_ selected: Int)
}

protocol IndexGettableComponent {
    var selectedIndex: Observable<Int> { get }
}

protocol ItemSettableComponent {
    func setItems(_ items: [String])
}

protocol NavigationItemComponent: TextValueSettableComponent { }

protocol SegmentComponent: ItemSettableComponent, IndexGettableComponent, IndexSettableComponent { }

protocol TabBarItemComponent: TextValueSettableComponent {
    func setIcon(_ tabIcon: TabIcon)
}

protocol ButtonComponent: TextValueSettableComponent, ActionSettableComponent { }

protocol LabelComponent: TextValueSettableComponent { }

protocol TextFieldComponent: TextValueSettableComponent {
    var textValue: Observable<String?> { get }
    var beganEditing: Observable<Void> { get }
    var endedEditing: Observable<Void> { get }
    
    func setActive(_ isActive: Bool)
    func setPlaceholderText(_ text: String?)
}

protocol EmailTextFieldComponent: TextFieldComponent {
    func applyEmailConfiguration()
}

protocol PasswordTextFieldComponent: TextFieldComponent {
    func applyPasswordConfiguration()
}
