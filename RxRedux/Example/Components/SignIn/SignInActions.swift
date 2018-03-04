import Foundation

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
