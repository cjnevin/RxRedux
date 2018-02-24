import Foundation

extension Reducers {
    static func reduce(_ state: SignInState, _ action: ActionType) -> SignInState {
        var state = state
        
        switch action {
        case let signInAction as SignInFormAction:
            switch signInAction {
            case .request:
                state.isSigningIn = true
                state.serverError = nil
            case .handleSuccess(let user):
                state.signedInUser = user
                state.isSigningIn = false
                state.isSignedIn = true
            case .handleError(let error):
                state.isSigningIn = false
                state.serverError = error.localizedDescription
            case .touchEmail:
                state.emailEditedOnce = true
            case .updateEmail(let email):
                state.email = email
            case .touchPassword:
                state.passwordEditedOnce = true
            case .updatePassword(let password):
                state.password = password
            }
        case let signOutAction as SignOutFormAction:
            switch signOutAction {
            case .request:
                state.isSigningOut = true
            case .handleSuccess:
                state.signedInUser = nil
                state.isSignedIn = false
                state.isSigningOut = false
            }
        default:
            break
        }
        
        return state
    }
}
