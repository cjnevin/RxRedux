import Foundation

struct SignInState: StateType, Equatable, Codable {
    static func ==(lhs: SignInState, rhs: SignInState) -> Bool {
        let encoder = JSONEncoder()
        guard let left = try? encoder.encode(lhs), let right = try? encoder.encode(rhs) else {
            return false
        }
        return left.elementsEqual(right)
    }
    
    private(set) var signedInUser: SignedInUser?
    
    private(set) var isSignedIn = false
    private(set) var isSigningIn = false
    private(set) var isSigningOut = false
    
    private(set) var serverError: String?
    
    private(set) var email: String?
    private(set) var emailEditedOnce = false
    
    private(set) var password: String?
    private(set) var passwordEditedOnce = false

    mutating func reduce(_ action: ActionType) {
        switch action {
        case AppLifecycleAction.ready:
            isSigningIn = false
            isSigningOut = false
        case let genderAction as AccountGenderAction:
            reduce(genderAction)
        case let signInAction as SignInFormAction:
            reduce(signInAction)
        case let signOutAction as SignOutFormAction:
            reduce(signOutAction)
        default:
            break
        }
    }
    
    private mutating func reduce(_ action: AccountGenderAction) {
        switch action {
        case .setMale:
            signedInUser?.gender = .male
        case .setFemale:
            signedInUser?.gender = .female
        }
    }
    
    private mutating func reduce(_ action: SignInFormAction) {
        switch action {
        case .request:
            isSigningIn = true
            serverError = nil
        case .handleSuccess(let user):
            signedInUser = user
            isSigningIn = false
            isSignedIn = true
        case .handleError(let error):
            isSigningIn = false
            serverError = error.localizedDescription
        case .touchEmail:
            emailEditedOnce = true
        case .updateEmail(let newEmail):
            email = newEmail
        case .touchPassword:
            passwordEditedOnce = true
        case .updatePassword(let newPassword):
            password = newPassword
        }
    }
    
    private mutating func reduce(_ action: SignOutFormAction) {
        switch action {
        case .request:
            isSigningOut = true
        case .handleSuccess:
            signedInUser = nil
            isSignedIn = false
            isSigningOut = false
        }
    }
}

extension SignInState {
    var isEmailValid: Bool {
        return Validation.isValid(email: email ?? "")
    }
    
    var isPasswordValid: Bool {
        return Validation.isValid(password: password ?? "")
    }
    
    var isFormValid: Bool {
        return isEmailValid && isPasswordValid
    }
}

private enum Validation {
    static func isValid(email: String) -> Bool {
        return email.count > 5
    }
    
    static func isValid(password: String) -> Bool {
        return password.count > 3
    }
}
