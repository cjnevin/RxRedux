import UIKit
import SnapKit
import RxSwift
import Action

class SignInOutButton: UIButton { }

struct MaleTabIcon: TabIcon {
    let image: UIImage = #imageLiteral(resourceName: "account-male-empty")
    let selectedImage: UIImage = #imageLiteral(resourceName: "account-male-filled")
}

struct FemaleTabIcon: TabIcon {
    let image: UIImage = #imageLiteral(resourceName: "account-female-empty")
    let selectedImage: UIImage = #imageLiteral(resourceName: "account-female-filled")
}

struct SignInTabIcon: TabIcon {
    let image: UIImage = #imageLiteral(resourceName: "sign-in-empty")
    let selectedImage: UIImage = #imageLiteral(resourceName: "sign-in-filled")
}

extension SignedInUser.Gender {
    var tabIcon: TabIcon {
        switch self {
        case .male: return MaleTabIcon()
        case .female: return FemaleTabIcon()
        }
    }
}

class SignInViewController: UIViewController {
    private lazy var containerView = UIView()
    private lazy var signInView = SignInView(SignInAccessibility.signInContainer)
    private lazy var signedInView = SignedInView(AccountAccessibility.accountContainer)
    private lazy var loadingView = LoadingView(SignInAccessibility.loading)
    private lazy var button = SignInOutButton(SignInAccessibility.signInOutButton)
    
    var presenter: SignInPresenter<SignInViewController>? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        presenter?.attachView(self)
    }
    
    deinit {
        presenter?.detachView()
    }
}

extension SignInViewController: SignInContainerType {
    func selectedGender() -> Observable<Int> {
        return signedInView.selectedGender()
    }
    
    func setGenders(_ genders: [String]) {
        signedInView.setGenders(genders)
    }
    
    func setSelectedGender(_ selected: Int) {
        signedInView.setSelectedGender(selected)
    }
    
    func setButtonAction(_ action: CocoaAction) {
        button.rx.action = action
    }
    
    func setButtonTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func setViewModel(_ viewModel: SignInViewModel) {
        signInView.viewModel = viewModel
        signedInView.viewModel = viewModel
        button.isUserInteractionEnabled = viewModel.isButtonEnabled
        
        view.layoutIfNeeded()
        
        signInView.updateLayout()
        
        containerView.snp.remakeConstraints { (make) in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            if viewModel.isLoadingShown {
                make.bottom.equalTo(loadingView).offset(30)
            } else {
                make.bottom.equalTo(viewModel.isSignInShown ? signInView : signedInView)
            }
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            self.loadingView.alpha = viewModel.isLoadingShown ? 1 : 0
            self.button.alpha = viewModel.isButtonEnabled ? 1 : 0.5
            self.signInView.updateAlpha()
            self.signedInView.updateAlpha()
            
            self.view.layoutIfNeeded()
        })
    }
    
    func beganEditingPassword() -> Observable<Void> {
        return signInView.beganEditingPassword()
    }
    
    func beganEditingEmail() -> Observable<Void> {
        return signInView.beganEditingEmail()
    }
    
    func editedPassword() -> Observable<String?> {
        return signInView.editedPassword()
    }
    
    func editedEmail() -> Observable<String?> {
        return signInView.editedEmail()
    }
    
    func endedEditingPassword() -> Observable<Void> {
        return signInView.endedEditingPassword()
    }
    
    func endedEditingEmail() -> Observable<Void> {
        return signInView.endedEditingEmail()
    }
    
    func setEmailError(_ text: String) {
        signInView.setEmailError(text)
    }
    
    func setPasswordError(_ text: String) {
        signInView.setPasswordError(text)
    }
    
    func setEmailPlaceholder(_ text: String) {
        signInView.setEmailPlaceholder(text)
    }
    
    func setPasswordPlaceholder(_ text: String) {
        signInView.setPasswordPlaceholder(text)
    }
    
    func selectPassword() {
        signInView.selectPassword()
    }
    
    func dismissKeyboard() {
        signInView.dismissKeyboard()
    }
}

// MARK: - Layout

extension SignInViewController {
    private func layout() {
        [containerView, button].forEach(view.addSubview)
        [signedInView, signInView, loadingView].forEach(containerView.addSubview)
        
        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(signInView)
        }
        
        signInView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(containerView)
        }
        
        signedInView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(containerView)
        }
        
        loadingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
}
