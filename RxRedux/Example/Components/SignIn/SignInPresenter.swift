import Foundation
import RxSwift
import Action

class SignInPresenter<T: SignInContainerType>: Presenter<T> {
     override func attachView(_ view: T) {
        super.attachView(view)
        
        let genders = [SignedInUser.Gender.male,
                       SignedInUser.Gender.female]
        
        let genderObservable = state.listen(\.signInState)
            .filter { $0.isSignedIn }
            .map { ($0.signedInUser?.gender ?? .male) }
            .distinctUntilChanged()

        let disposables = [
            view.beganEditingEmail()
                .subscribe(onNext: {
                    fire.onNext(SignInFormAction.touchEmail)
                }),
            
            view.beganEditingPassword()
                .subscribe(onNext: {
                    fire.onNext(SignInFormAction.touchPassword)
                }),
            
            view.editedEmail()
                .subscribe(onNext: { (text) in
                    fire.onNext(SignInFormAction.updateEmail(text ?? ""))
                }),
            
            view.editedPassword()
                .subscribe(onNext: { (text) in
                    fire.onNext(SignInFormAction.updatePassword(text ?? ""))
                }),
            
            view.endedEditingEmail()
                .subscribe(onNext: { _ in
                    view.selectPassword()
                }),
            
            view.endedEditingPassword()
                .subscribe(onNext: { (_) in
                    view.dismissKeyboard()
                    fire.onNext(signIn())
                }),
            
            state.localized()
                .subscribe(onNext: { _ in
                    view.setGenders(genders.map { "account.gender.\($0.rawValue)".localized() })
                    view.setEmailError("sign.in.email.invalid".localized())
                    view.setEmailPlaceholder("sign.in.email.placeholder".localized())
                    view.setPasswordError("sign.in.password.invalid".localized())
                    view.setPasswordPlaceholder("sign.in.password.placeholder".localized())
                }),
            
            state.localizedListen(\.signInState.isSignedIn)
                .subscribe(onNext: { (isSignedIn) in
                    if isSignedIn {
                        view.setButtonAction(CocoaAction() {
                            .just(fire.onNext(signOut()))
                        })
                        view.setTabTitle("sign.out.tab.title".localized())
                        view.setTitle("sign.out.title".localized())
                        view.setButtonTitle("sign.out.button".localized())
                    } else {
                        view.setButtonAction(CocoaAction() {
                            view.dismissKeyboard()
                            return .just(fire.onNext(signIn()))
                        })
                        view.setTabTitle("sign.in.tab.title".localized())
                        view.setTitle("sign.in.title".localized())
                        view.setButtonTitle("sign.in.button".localized())
                    }
                }),
            
            state.listen(\.signInState)
                .map(SignInViewModel.init)
                .subscribe(onNext: view.setViewModel),
            
            view.selectedGender()
                .subscribe(onNext: { (index) in
                    if genders[index] == .male {
                        fire.onNext(AccountGenderAction.setMale)
                    } else {
                        fire.onNext(AccountGenderAction.setFemale)
                    }
                }),
            
            Observable.combineLatest(state.localized(), genderObservable)
                .map { genders.index(of: $1) ?? 0 }
                .subscribe(onNext: { (index) in
                    view.setSelectedGender(index)
                }),
            
            genderObservable
                .map { $0.tabIcon }
                .subscribe(onNext: view.setTabIcon),
            
            state.listen(\.signInState.isSignedIn)
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
