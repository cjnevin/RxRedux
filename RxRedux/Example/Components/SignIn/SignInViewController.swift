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

extension Gender {
    var tabIcon: TabIcon {
        switch self {
        case .male: return MaleTabIcon()
        case .female: return FemaleTabIcon()
        }
    }
}

class SignInViewController: UIViewController {
    private lazy var containerView = UIView()
    lazy var signInView = SignInView(SignInAccessibility.signInContainer)
    lazy var signedInView = SignedInView(AccountAccessibility.accountContainer)
    private lazy var loadingView = LoadingView(SignInAccessibility.loading)
    lazy var button = SignInOutButton(SignInAccessibility.signInOutButton)
    
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

extension SignInViewController: SignInContainerComponent {
    var tabItem: UITabBarItem {
        return navigationController!.tabBarItem
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
