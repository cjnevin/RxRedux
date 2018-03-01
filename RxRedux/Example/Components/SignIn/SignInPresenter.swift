import Foundation
import RxSwift
import Action

class SignInPresenter<T: SignInContainerComponent>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(CompositeDisposable(disposables: [
            configureStaticText(view),
            configureSignInStatusText(view),
            configureEmail(view.signInView.emailTextField, passwordTextField: view.signInView.passwordTextField),
            configureGenderSelection(view.signedInView.genderSegment),
            configureTabIcon(view.tabItem),
            configureViewModel(view)
        ]))
    }
    
    private func configureEmail(_ textField: EmailTextFieldComponent, passwordTextField: PasswordTextFieldComponent) -> Disposable {
        let emailDisposable = CompositeDisposable(disposables: [
            textField.textValue.skip(1).subscribe(onNext: { text in
                store.dispatch(SignInFormAction.updateEmail(text ?? ""))
            }),
            
            textField.beganEditing.take(1).subscribe(onNext: {
                store.dispatch(SignInFormAction.touchEmail)
            }),
            
            textField.endedEditing.subscribe(onNext: {
                passwordTextField.setActive(true)
            })
            ])
        
        textField.applyEmailConfiguration()
        
        return CompositeDisposable(disposables: [
            emailDisposable,
            configurePassword(passwordTextField)])
    }
    
    private func configurePassword(_ textField: PasswordTextFieldComponent) -> Disposable {
        textField.applyPasswordConfiguration()
        
        return CompositeDisposable(disposables: [
            textField.textValue.skip(1).subscribe(onNext: { text in
                store.dispatch(SignInFormAction.updatePassword(text ?? ""))
            }),
            
            textField.beganEditing.take(1).subscribe(onNext: {
                store.dispatch(SignInFormAction.touchPassword)
            }),
            
            textField.endedEditing.subscribe(onNext: { text in
                textField.setActive(false)
                store.dispatch(signIn())
            })
            ])
    }
    
    private func configureViewModel<T: SignInContainerComponent>(_ view: T) -> Disposable {
        return store.observe(\.signInState)
            .map(SignInViewModel.init)
            .subscribe(onNext: view.setViewModel)
    }
    
    private func configureStaticText<T: SignInContainerComponent>(_ view: T) -> Disposable {
        return store.localizedObserve()
            .subscribe(onNext: { _ in
                view.signedInView.genderSegment.setItems(Gender.all.map { "account.gender.\($0.rawValue)".localized() })
                view.signInView.emailErrorLabel.setTextValue("sign.in.email.invalid".localized())
                view.signInView.emailTextField.setPlaceholderText("sign.in.email.placeholder".localized())
                view.signInView.passwordErrorLabel.setTextValue("sign.in.password.invalid".localized())
                view.signInView.passwordTextField.setPlaceholderText("sign.in.password.placeholder".localized())
            })
    }
    
    private func configureSignInStatusText<T: SignInContainerComponent>(_ view: T) -> Disposable {
        return store.localizedObserve(\.signInState.isSignedIn)
            .subscribe(onNext: { (isSignedIn) in
                if isSignedIn {
                    view.button.setAction(CocoaAction() {
                        return .just(store.dispatch(signOut()))
                    })
                    view.tabItem.setTextValue("sign.out.tab.title".localized())
                    view.navigationItem.setTextValue("sign.out.title".localized())
                    view.button.setTextValue("sign.out.button".localized())
                } else {
                    view.button.setAction(CocoaAction() {
                        view.signInView.emailTextField.setActive(false)
                        view.signInView.passwordTextField.setActive(false)
                        return .just(store.dispatch(signIn()))
                    })
                    view.tabItem.setTextValue("sign.in.tab.title".localized())
                    view.navigationItem.setTextValue("sign.in.title".localized())
                    view.button.setTextValue("sign.in.button".localized())
                }
            })
    }
    
    private func configureGenderSelection(_ segment: SegmentComponent) -> Disposable {
        return CompositeDisposable(disposables: [
            Observable.combineLatest(store.localizedObserve(), gender)
                .map { Gender.all.index(of: $1) ?? 0 }
                .subscribe(onNext: segment.setSelectedIndex),
            
            segment.selectedIndex
                .map { AccountGenderAction.setGender(Gender.all[$0]) }
                .subscribe(onNext: store.dispatch)
        ])
    }
    
    private func configureTabIcon(_ tabItem: TabBarItemComponent) -> Disposable {
        let tabIcon = Observable.merge(
            gender.map { $0.tabIcon },
            store.observe(\.signInState.isSignedIn).filter { !$0 }.map { _ in SignInTabIcon() }
        )
        return tabIcon.subscribe(onNext: tabItem.setIcon)
    }
}

extension SignInPresenter {
    private var gender: Observable<Gender> {
        return store.observe(\.signInState)
            .filter { $0.isSignedIn }
            .map { ($0.signedInUser?.gender ?? .male) }
            .distinctUntilChanged()
    }
}

protocol SignInContainerComponent {
    associatedtype NavigationItem: NavigationItemComponent
    associatedtype TabBarItem: TabBarItemComponent
    associatedtype Button: ButtonComponent
    associatedtype SignIn: SignInComponent
    associatedtype SignedIn: SignedInComponent
    
    var navigationItem: NavigationItem { get }
    var tabItem: TabBarItem { get }
    var button: Button { get }
    var signInView: SignIn { get }
    var signedInView: SignedIn { get }
    func setViewModel(_ viewModel: SignInViewModel)
}

protocol SignedInComponent {
    associatedtype Gender: SegmentComponent
    var genderSegment: Gender { get }
}

protocol SignInComponent {
    associatedtype Password: PasswordTextFieldComponent
    associatedtype Email: EmailTextFieldComponent
    associatedtype EmailError: LabelComponent
    associatedtype PasswordError: LabelComponent
    
    var passwordTextField: Password { get }
    var emailTextField: Email { get }
    var emailErrorLabel: EmailError { get }
    var passwordErrorLabel: PasswordError { get }
}
