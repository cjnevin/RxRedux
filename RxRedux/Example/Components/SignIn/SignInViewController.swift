import UIKit
import SnapKit
import RxSwift

enum SignInAccessibility: String {
    case formInvalid
    case emailInvalid
    case email
    case passwordInvalid
    case password
    case signInButton
    case signOutButton
    case loading
}

enum AccountAccessibility: String {
    case signOutButton
    case name
}

class SignOutButton: UIButton, LocalizableTitle { }
class AccountFirstNameLabel: UILabel { }
class AccountLastNameLabel: UILabel { }

class SignInErrorLabel: UILabel { }
class SignInLocalizableErrorLabel: SignInErrorLabel, LocalizableTitle { }
class SignInButton: UIButton, LocalizableTitle { }
class SignInEmailField: UITextField, LocalizablePlaceholder {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        keyboardType = .emailAddress
        returnKeyType = .next
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}
class SignInPasswordField: UITextField, LocalizablePlaceholder {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        isSecureTextEntry = true
        keyboardType = .default
        returnKeyType = .send
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}

class SignInViewController: UIViewController, LocalizableTitle {
    // Sign In ...
    private lazy var formInvalidLabel = SignInErrorLabel(SignInAccessibility.formInvalid)
    private lazy var emailInvalidLabel = SignInLocalizableErrorLabel(SignInAccessibility.emailInvalid)
    private lazy var emailTextField = SignInEmailField(SignInAccessibility.email)
    private lazy var passwordInvalidLabel = SignInLocalizableErrorLabel(SignInAccessibility.passwordInvalid)
    private lazy var passwordTextField = SignInPasswordField(SignInAccessibility.password)
    private lazy var signInButton = SignInButton(SignInAccessibility.signInButton)
    
    // Signed In ...
    private lazy var signOutButton = SignOutButton(AccountAccessibility.signOutButton)
    private lazy var nameLabel = AccountFirstNameLabel(AccountAccessibility.name)
    
    // Shared
    private lazy var loadingView = LoadingView(SignInAccessibility.loading)
    private lazy var disposable = SingleAssignmentDisposable()
    
    private func updateState(with viewModel: SignInViewModel) {
        emailTextField.text = viewModel.email
        passwordTextField.text = viewModel.password
        formInvalidLabel.text = viewModel.serverError
        signInButton.isEnabled = viewModel.isSignInEnabled
        nameLabel.text = viewModel.name
        
        view.layoutIfNeeded()
        
        updateConstraints(with: viewModel)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            self.nameLabel.alpha = viewModel.isNameShown ? 1 : 0
            self.signInButton.alpha = viewModel.isSignInShown ? (viewModel.isSignInEnabled ? 1 : 0.5) : 0
            self.signOutButton.alpha = viewModel.isSignOutShown ? (viewModel.isSignOutEnabled ? 1 : 0.5) : 0
            self.emailTextField.alpha = viewModel.isEmailShown ? 1 : 0
            self.passwordTextField.alpha = viewModel.isPasswordShown ? 1 : 0
            self.loadingView.alpha = viewModel.isLoading ? 1 : 0
            
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        render()
        bind()
    }
}

// MARK: - Binding

extension SignInViewController {
    private func bind() {
        disposable.setDisposable(CompositeDisposable(disposables: [
            bindState(),
            bindEmailField(),
            bindPasswordField(),
            bindSignInButton(),
            bindSignOutButton(),
            bindStaticLocalizedText(),
            bindTitle()
        ]))
    }
    
    private func bindStaticLocalizedText() -> Disposable {
        return CompositeDisposable(disposables: [
            emailInvalidLabel.setTitle("sign.in.email.invalid"),
            emailTextField.setPlaceholder("sign.in.email.placeholder"),
            passwordInvalidLabel.setTitle("sign.in.password.invalid"),
            passwordTextField.setPlaceholder("sign.in.password.placeholder"),
            signInButton.setTitle("sign.in.button"),
            signOutButton.setTitle("sign.out.button")
        ])
    }
    
    private func bindTitle() -> Disposable {
        return store.uniquelyObserve(\.signInState.isSignedIn)
            .map { $0 ? "sign.out.title" : "sign.in.title" }
            .flatMap({ (localizationKey) in
                return Observable<String>.create { _ in
                    self.setTitle(localizationKey)
                }
            }).subscribe()
    }
    
    private func bindState() -> Disposable {
        return store.observe(\.signInState)
            .map(SignInViewModel.init)
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { [weak self] (viewModel) in
                self?.updateState(with: viewModel)
            })
    }
    
    private func bindSignInButton() -> Disposable {
        return signInButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.emailTextField.resignFirstResponder()
                self?.passwordTextField.resignFirstResponder()
                store.dispatch(signIn())
            })
    }
    
    private func bindSignOutButton() -> Disposable {
        return signOutButton.rx.tap.subscribe(onNext: { store.dispatch(signOut()) })
    }
    
    private func bindEmailField() -> Disposable {
        return CompositeDisposable(disposables: [
            emailTextField.rx.controlEvent(.editingDidBegin).take(1)
                .subscribe(onNext: {
                    store.dispatch(SignInFormAction.touchEmail)
                }),
            emailTextField.rx.controlEvent(.editingDidEnd)
                .subscribe(onNext: { [weak self] _ in
                    self?.passwordTextField.becomeFirstResponder()
                }),
            emailTextField.rx.text
                .subscribe(onNext: { (text) in
                    store.dispatch(SignInFormAction.updateEmail(text ?? ""))
                })
            ])
    }
    
    private func bindPasswordField() -> Disposable {
        return CompositeDisposable(disposables: [
            passwordTextField.rx.controlEvent(.editingDidBegin).take(1)
                .subscribe(onNext: {
                    store.dispatch(SignInFormAction.touchPassword)
                }),
            passwordTextField.rx.controlEvent(.editingDidEnd)
                .subscribe(onNext: { [weak self] _ in
                    self?.passwordTextField.resignFirstResponder()
                }),
            passwordTextField.rx.text
                .subscribe(onNext: { (text) in
                    store.dispatch(SignInFormAction.updatePassword(text ?? ""))
                })
            ])
    }
}


// MARK: - Constraints

extension SignInViewController {
    private func updateConstraints(with viewModel: SignInViewModel) {
        emailTextField.snp.updateConstraints { (make) in
            make.top.equalTo(formInvalidLabel.snp.bottom).offset(viewModel.isLoading ? 0 : 20)
        }
        passwordTextField.snp.updateConstraints { (make) in
            make.top.equalTo(emailInvalidLabel.snp.bottom).offset(viewModel.isLoading ? 0 : 20)
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
        
        signOutButton.snp.remakeConstraints { (make) in
            if viewModel.isSignOutShown {
                if viewModel.isLoading {
                    make.top.equalTo(loadingView.snp.bottom).offset(30)
                } else {
                    make.top.equalTo(nameLabel.snp.bottom).offset(20)
                }
            } else {
                make.top.equalTo(signInButton.snp.top)
            }
            make.height.equalTo(60)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func render() {
        [formInvalidLabel,
         emailInvalidLabel, emailTextField,
         passwordInvalidLabel, passwordTextField,
         signInButton, signOutButton, nameLabel, loadingView].forEach(view.addSubview)
        
        // Sign in ...
        formInvalidLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(0)
        }
        loadingView.snp.makeConstraints { make in
            make.top.equalTo(formInvalidLabel.snp.bottom).offset(15)
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(formInvalidLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        emailInvalidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom)
            make.height.equalTo(0)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailInvalidLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        passwordInvalidLabel.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.height.equalTo(0)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        signInButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordInvalidLabel.snp.bottom).offset(20)
            make.height.equalTo(60)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        // Account ...
        nameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        signOutButton.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.height.equalTo(60)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
