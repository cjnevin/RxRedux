import Foundation

struct SignInState {
    var signedInUser: SignedInUser?
    
    var isSignedIn = false
    var isSigningIn = false
    var isSigningOut = false
    
    var serverError: String?
    
    var email: String?
    var emailEditedOnce = false
    
    var password: String?
    var passwordEditedOnce = false
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
