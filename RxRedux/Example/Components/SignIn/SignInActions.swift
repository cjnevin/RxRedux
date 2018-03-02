import Foundation

func signIn() -> ActionType {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
        DispatchQueue.main.async {
            if drand48() > 0.5 {
                fire.onNext(SignInFormAction.handleError(SignInError.incorrectCredentials))
            } else {
                fire.onNext(SignInFormAction.handleSuccess(SignedInUser(id: 1, firstName: "John", lastName: "Smith", gender: nil)))
            }
        }
    }
    return SignInFormAction.request
}

func signOut() -> ActionType {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
        DispatchQueue.main.async {
            fire.onNext(SignOutFormAction.handleSuccess)
        }
    }
    return SignOutFormAction.request
}

enum SignInFormAction: ActionType {
    case request
    case handleSuccess(SignedInUser)
    case handleError(Error)
    
    case touchEmail
    case updateEmail(String)
    
    case touchPassword
    case updatePassword(String)
}

enum SignOutFormAction: ActionType {
    case request
    case handleSuccess
}

enum AccountGenderAction: ActionType {
    case setMale
    case setFemale
}
