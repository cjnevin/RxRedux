import Foundation

struct SignInViewModel {
    let email: String
    let password: String
    
    let name: String?
    
    let serverError: String?
    
    let hideServerError: Bool
    let hideEmailError: Bool
    let hidePasswordError: Bool
    
    let isLoading: Bool
    let isFormValid: Bool
    let isSignInEnabled: Bool
    let isSignOutEnabled: Bool
    let isSignInShown: Bool
    let isSignOutShown: Bool
    let isEmailShown: Bool
    let isPasswordShown: Bool
    let isNameShown: Bool
    
    init?(state: SignInState) {
        email = state.email ?? ""
        password = state.password ?? ""
        
        if let firstName = state.signedInUser?.firstName, let lastName = state.signedInUser?.lastName {
            name = "\(firstName) \(lastName)"
        } else {
            name = nil
        }
        
        serverError = state.serverError
        
        hideEmailError = state.isEmailValid ? true : state.emailEditedOnce ? false : true
        hidePasswordError = state.isPasswordValid ? true : state.passwordEditedOnce ? false : true
        hideServerError = state.serverError == nil
        
        isLoading = state.isSigningIn || state.isSigningOut
        isFormValid = state.isFormValid
        isSignInEnabled = isFormValid && !state.isSigningIn
        isSignInShown = !state.isSignedIn
        isSignOutShown = state.isSignedIn
        isSignOutEnabled = state.isSignedIn && !state.isSigningOut
        isEmailShown = !state.isSignedIn && !state.isSigningIn
        isPasswordShown = isEmailShown
        isNameShown = state.isSignedIn && !state.isSigningOut
    }
}
