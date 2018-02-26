import Foundation
import RxSwift
import Action

class SignInPresenter<T: SignInContainerType>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        
        let genders = [SignedInUser.Gender.male,
                       SignedInUser.Gender.female]
        
        let genderObservable = store.observe(\AppState.signInState)
            .filter { $0.isSignedIn }
            .map { ($0.signedInUser?.gender ?? .male) }
            .distinctUntilChanged()
        
        let disposables = [
            view.beganEditingEmail()
                .subscribe(onNext: {
                    store.dispatch(SignInFormAction.touchEmail)
                }),
            
            view.beganEditingPassword()
                .subscribe(onNext: {
                    store.dispatch(SignInFormAction.touchPassword)
                }),
            
            view.editedEmail()
                .subscribe(onNext: { (text) in
                    store.dispatch(SignInFormAction.updateEmail(text ?? ""))
                }),
            
            view.editedPassword()
                .subscribe(onNext: { (text) in
                    store.dispatch(SignInFormAction.updatePassword(text ?? ""))
                }),
            
            view.endedEditingEmail()
                .subscribe(onNext: { _ in
                    view.selectPassword()
                }),
            
            view.endedEditingPassword()
                .subscribe(onNext: { (_) in
                    view.dismissKeyboard()
                    store.dispatch(signIn())
                }),
            
            store.localizedObserve()
                .subscribe(onNext: { _ in
                    view.setGenders(genders.map { "account.gender.\($0.rawValue)".localized() })
                    view.setEmailError("sign.in.email.invalid".localized())
                    view.setEmailPlaceholder("sign.in.email.placeholder".localized())
                    view.setPasswordError("sign.in.password.invalid".localized())
                    view.setPasswordPlaceholder("sign.in.password.placeholder".localized())
                }),
            
            store.localizedObserve(\.signInState.isSignedIn)
                .subscribe(onNext: { (isSignedIn) in
                    if isSignedIn {
                        view.setButtonAction(CocoaAction() {
                            .just(store.dispatch(signOut()))
                        })
                        view.setTabTitle("sign.out.tab.title".localized())
                        view.setTitle("sign.out.title".localized())
                        view.setButtonTitle("sign.out.button".localized())
                    } else {
                        view.setButtonAction(CocoaAction() {
                            .just(store.dispatch(signIn()))
                        })
                        view.setTabTitle("sign.in.tab.title".localized())
                        view.setTitle("sign.in.title".localized())
                        view.setButtonTitle("sign.in.button".localized())
                    }
                }),
            
            store.observe(\.signInState)
                .map(SignInViewModel.init)
                .subscribe(onNext: view.setViewModel),
            
            view.selectedGender()
                .subscribe(onNext: { (index) in
                    if genders[index] == .male {
                        store.dispatch(AccountGenderAction.setMale)
                    } else {
                        store.dispatch(AccountGenderAction.setFemale)
                    }
                }),
            
            Observable.combineLatest(store.localizedObserve(), genderObservable)
                .map { genders.index(of: $1) ?? 0 }
                .subscribe(onNext: { (index) in
                    view.setSelectedGender(index)
                }),
            
            genderObservable
                .map { $0.tabIcon }
                .subscribe(onNext: view.setTabIcon),
            
            store.observe(\.signInState.isSignedIn)
                .filter { !$0 }
                .subscribe(onNext: { (_) in
                    view.setTabIcon(SignInTabIcon())
                })
        ]
        
        disposeOnViewDetach(disposables)
    }
}

protocol SignInContainerType: TitlableView, TabTitlableView, TabIconSettableView, SignInViewType, SignedInViewType {
    func setButtonAction(_ action: CocoaAction)
    func setButtonTitle(_ title: String)
    
    func setViewModel(_ viewModel: SignInViewModel)
}

protocol SignedInViewType {
    func selectedGender() -> Observable<Int>
    func setGenders(_ genders: [String])
    func setSelectedGender(_ selected: Int)
}

protocol SignInViewType {
    func beganEditingPassword() -> Observable<Void>
    func beganEditingEmail() -> Observable<Void>
    func editedPassword() -> Observable<String?>
    func editedEmail() -> Observable<String?>
    func endedEditingPassword() -> Observable<Void>
    func endedEditingEmail() -> Observable<Void>
    
    func setEmailError(_ text: String)
    func setPasswordError(_ text: String)
    func setEmailPlaceholder(_ text: String)
    func setPasswordPlaceholder(_ text: String)
    
    func selectPassword()
    func dismissKeyboard()
}
