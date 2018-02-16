import UIKit
import SnapKit
import Action

enum CountViewAccessibility: String {
    case countValueLabel
    case countDecrementButton
    case countIncrementButton
}

class CountViewController: UIViewController {
    fileprivate lazy var countLabel: UILabel = .make(accessibilityIdentifier: .countValueLabel)
    fileprivate lazy var decrementButton: UIButton = .make(text: "Decrement", accessibilityIdentifier: .countDecrementButton)
    fileprivate lazy var incrementButton: UIButton = .make(text: "Increment", accessibilityIdentifier: .countIncrementButton)
    
    var presenter: CountPresenter<CountViewController>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.attachView(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.detachView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [countLabel, decrementButton, incrementButton].forEach(view.addSubview)
        
        let padding = CGFloat(20)
        
        countLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(padding)
        }
        
        decrementButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(padding)
        }
        
        incrementButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.bottom.equalTo(decrementButton.snp.top).offset(-20)
        }
    }
}

extension CountViewController: CountView {
    func setCountText(_ text: String) {
        countLabel.text = text
    }
    
    func setDecrementAction(_ action: CocoaAction) {
        decrementButton.rx.action = action
    }
    
    func setIncrementAction(_ action: CocoaAction) {
        incrementButton.rx.action = action
    }
}

fileprivate extension UILabel {
    static func make(
        backgroundColor: UIColor = .clear,
        textColor: UIColor = .black,
        text: String = "",
        accessibilityIdentifier: CountViewAccessibility? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        if let accessibilityIdentifier = accessibilityIdentifier?.rawValue {
            label.accessibilityIdentifier = accessibilityIdentifier
            label.isAccessibilityElement = true
        }
        return label
    }
}

fileprivate extension UIButton {
    static func make(
        backgroundColor: UIColor = .lightGray,
        textColor: UIColor = .black,
        text: String = "",
        disabledTextColor: UIColor = UIColor.lightText,
        accessibilityIdentifier: CountViewAccessibility? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.setTitleColor(disabledTextColor, for: .disabled)
        button.backgroundColor = backgroundColor
        if let accessibilityIdentifier = accessibilityIdentifier?.rawValue {
            button.accessibilityIdentifier = accessibilityIdentifier
            button.isAccessibilityElement = true
        }
        return button
    }
}
