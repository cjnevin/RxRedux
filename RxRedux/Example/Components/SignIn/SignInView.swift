import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Action

enum SignInAccessibility: String {
    case signInContainer
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
class SignInEmailField: UITextField, EmailTextFieldComponent { }
class SignInPasswordField: UITextField, PasswordTextFieldComponent { }

class SignInView: UIView, SignInComponent {
    private lazy var formInvalidLabel = SignInErrorLabel(SignInAccessibility.formInvalid)
    lazy var emailErrorLabel = SignInLocalizableErrorLabel(SignInAccessibility.emailInvalid)
    lazy var emailTextField = SignInEmailField(SignInAccessibility.email)
    lazy var passwordErrorLabel = SignInLocalizableErrorLabel(SignInAccessibility.passwordInvalid)
    lazy var passwordTextField = SignInPasswordField(SignInAccessibility.password)
    
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
        
        alpha = viewModel.isSignOutShown ? 0 : 1
        emailTextField.alpha = viewModel.isEmailShown ? 1 : 0
        passwordTextField.alpha = viewModel.isPasswordShown ? 1 : 0
    }
    
    func updateLayout() {
        guard let viewModel = viewModel else { return }
        
        emailTextField.snp.updateConstraints { (make) in
            make.top.equalTo(formInvalidLabel.snp.bottom).offset(viewModel.serverError == nil ? 0 : 20)
        }
        passwordTextField.snp.updateConstraints { (make) in
            make.top.equalTo(emailErrorLabel.snp.bottom).offset(viewModel.isLoadingShown ? 0 : 20)
        }
        formInvalidLabel.snp.updateConstraints { make in
            make.height.equalTo(viewModel.hideServerError ? 0 : 30)
        }
        emailErrorLabel.snp.updateConstraints { make in
            make.height.equalTo(viewModel.hideEmailError ? 0 : 30)
        }
        passwordErrorLabel.snp.updateConstraints { make in
            make.height.equalTo(viewModel.hidePasswordError ? 0 : 30)
        }
    }
    
    private func layout() {
        [formInvalidLabel,
         emailErrorLabel, emailTextField,
         passwordErrorLabel, passwordTextField].forEach(addSubview)
        
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
        emailErrorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom)
            make.height.equalTo(0)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailErrorLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        passwordErrorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.height.equalTo(0)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(snp.bottom).inset(20)
        }
    }
}
