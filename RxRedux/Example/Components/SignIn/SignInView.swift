import UIKit
import RxSwift
import SnapKit

enum SignInAccessibility: String {
    case formInvalid
    case emailInvalid
    case email
    case passwordInvalid
    case password
    case signInOutButton
    case loading
}

class SignInErrorLabel: UILabel { }
class SignInLocalizableErrorLabel: SignInErrorLabel { }
class SignInEmailField: UITextField {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        keyboardType = .emailAddress
        returnKeyType = .next
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}
class SignInPasswordField: UITextField {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        isSecureTextEntry = true
        keyboardType = .default
        returnKeyType = .send
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}

class SignInView: UIView {
    private lazy var formInvalidLabel = SignInErrorLabel(SignInAccessibility.formInvalid)
    private lazy var emailInvalidLabel = SignInLocalizableErrorLabel(SignInAccessibility.emailInvalid)
    private lazy var emailTextField = SignInEmailField(SignInAccessibility.email)
    private lazy var passwordInvalidLabel = SignInLocalizableErrorLabel(SignInAccessibility.passwordInvalid)
    private lazy var passwordTextField = SignInPasswordField(SignInAccessibility.password)
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        layout()
    }
    
    var viewModel: SignInViewModel? {
        didSet {
            emailTextField.text = viewModel?.email
            passwordTextField.text = viewModel?.password
            formInvalidLabel.text = viewModel?.serverError
        }
    }
    
    func updateAlpha() {
        guard let viewModel = viewModel else { return }
        
        emailTextField.alpha = viewModel.isEmailShown ? 1 : 0
        passwordTextField.alpha = viewModel.isPasswordShown ? 1 : 0
    }
    
    func updateLayout() {
        guard let viewModel = viewModel else { return }
        
        emailTextField.snp.updateConstraints { (make) in
            make.top.equalTo(formInvalidLabel.snp.bottom).offset(viewModel.isLoadingShown ? 0 : 20)
        }
        passwordTextField.snp.updateConstraints { (make) in
            make.top.equalTo(emailInvalidLabel.snp.bottom).offset(viewModel.isLoadingShown ? 0 : 20)
        }
        formInvalidLabel.snp.updateConstraints { make in
            make.height.equalTo(viewModel.hideServerError ? 0 : 30)
        }
        emailInvalidLabel.snp.updateConstraints { make in
            make.height.equalTo(viewModel.hideEmailError ? 0 : 30)
        }
        passwordInvalidLabel.snp.updateConstraints { make in
            make.height.equalTo(viewModel.hidePasswordError ? 0 : 30)
        }
    }
    
    private func layout() {
        [formInvalidLabel,
         emailInvalidLabel, emailTextField,
         passwordInvalidLabel, passwordTextField].forEach(addSubview)
        
        // Sign in ...
        formInvalidLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(formInvalidLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        emailInvalidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom)
            make.height.equalTo(0)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailInvalidLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        passwordInvalidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.height.equalTo(0)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(snp.bottom).inset(20)
        }
    }
}

extension SignInView: SignInViewType {
    func beganEditingPassword() -> Observable<Void> {
        return passwordTextField.rx.controlEvent(.editingDidBegin).take(1)
    }
    
    func beganEditingEmail() -> Observable<Void> {
        return emailTextField.rx.controlEvent(.editingDidBegin).take(1)
    }
    
    func endedEditingEmail() -> Observable<Void> {
        return emailTextField.rx.controlEvent(.editingDidEnd).asObservable()
    }
    
    func endedEditingPassword() -> Observable<Void> {
        return passwordTextField.rx.controlEvent(.editingDidEnd).asObservable()
    }
    
    func editedPassword() -> Observable<String?> {
        return passwordTextField.rx.text.skip(1)
    }
    
    func editedEmail() -> Observable<String?> {
        return emailTextField.rx.text.skip(1)
    }
    
    func setEmailError(_ text: String) {
        emailInvalidLabel.text = text
    }
    
    func setPasswordError(_ text: String) {
        passwordInvalidLabel.text = text
    }
    
    func setEmailPlaceholder(_ text: String) {
        emailTextField.placeholder = text
    }
    
    func setPasswordPlaceholder(_ text: String) {
        passwordTextField.placeholder = text
    }
    
    func selectPassword() {
        passwordTextField.becomeFirstResponder()
    }
    
    func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
