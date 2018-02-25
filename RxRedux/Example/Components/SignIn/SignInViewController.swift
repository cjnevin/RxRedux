import UIKit
import SnapKit
import RxSwift

class SignInViewController: UIViewController, LocalizableTitle {
    private lazy var containerView = UIView()
    private lazy var signInView = SignInView()
    private lazy var signedInView = SignedInView()
    private lazy var loadingView = LoadingView(SignInAccessibility.loading)
    private lazy var button = SignInButton(SignInAccessibility.signInOutButton)
    private lazy var disposable = SingleAssignmentDisposable()
    
    private func updateState(with viewModel: SignInViewModel) {
        signInView.viewModel = viewModel
        signedInView.viewModel = viewModel
        button.isEnabled = viewModel.isButtonEnabled
        
        view.bringSubview(toFront: viewModel.isSignInShown ? signInView : signedInView)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        layout()
        bind()
    }
}

// MARK: - Binding

extension SignInViewController {
    private func bind() {
        disposable.setDisposable(CompositeDisposable(disposables: [
            bindState(),
            bindButton(),
            bindButtonTitle(),
            bindTitle()
        ]))
    }
    
    private func bindTitle() -> Disposable {
        return store.uniquelyObserve(\.signInState.isSignedIn)
            .map { $0 ? "sign.out.title" : "sign.in.title" }
            .flatMap({ [weak self] (localizationKey) in
                return Observable<String>.create { _ in
                    self?.setTitle(localizationKey) ?? Disposables.create()
                }
            }).subscribe()
    }
    
    private func bindButtonTitle() -> Disposable {
        return store.uniquelyObserve(\.signInState.isSignedIn)
            .map { $0 ? "sign.out.button" : "sign.in.button" }
            .flatMap({ [weak self] (localizationKey) in
                return Observable<String>.create { _ in
                    self?.button.setTitle(localizationKey) ?? Disposables.create()
                }
            }).subscribe()
    }
    
    private func bindButton() -> Disposable {
        return button.rx.tap
            .withLatestFrom(store.observe(\.signInState.isSignedIn))
            .subscribe(onNext: { [weak self] isSignedIn in
                if isSignedIn {
                    store.dispatch(signOut())
                } else {
                    _ = self?.signInView.resignFirstResponder()
                    store.dispatch(signIn())
                }
            })
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
