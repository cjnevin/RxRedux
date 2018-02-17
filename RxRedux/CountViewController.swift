import UIKit
import SnapKit
import Action

enum CountViewAccessibility: String {
    case countValue
    case countDecrement
    case countIncrement
}

class CountViewController: UIViewController {
    fileprivate lazy var value = UILabel.value
    fileprivate lazy var decrement = UIButton.decrement
    fileprivate lazy var increment = UIButton.increment
    
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
        render()
    }
    
    func render() {
        view.backgroundColor = .white
        
        let padding = CGFloat(20)
        let buttonHeight = CGFloat(40)
        
        view.addSubview(value) { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(padding)
        }
        
        view.addSubview(decrement) { make in
            make.height.equalTo(buttonHeight)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(padding)
        }
        
        view.addSubview(increment) { (make) in
            make.height.equalTo(buttonHeight)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.bottom.equalTo(decrement.snp.top).offset(-padding)
        }
    }
}

extension CountViewController: CountView {
    func setCountText(_ text: String) {
        value.text = text
    }
    
    func setDecrementText(_ text: String, action: CocoaAction) {
        decrement.setTitle(text, for: .normal)
        decrement.rx.action = action
    }
    
    func setIncrementText(_ text: String, action: CocoaAction) {
        increment.setTitle(text, for: .normal)
        increment.rx.action = action
    }
}

fileprivate extension UILabel {
    static var value: UILabel {
        let label = UILabel(CountViewAccessibility.countValue)
        label.textColor = .black
        return label
    }
}

fileprivate extension UIButton {
    static var decrement: UIButton {
        let button = UIButton(CountViewAccessibility.countIncrement)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }
    
    static var increment: UIButton {
        let button = UIButton(CountViewAccessibility.countIncrement)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }
}

