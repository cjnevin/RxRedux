import Foundation

enum SignInError: Error, LocalizedError {
    case incorrectCredentials
    
    var errorDescription: String? {
        switch self {
        case .incorrectCredentials:
            return "Incorrect credentials provided"
        }
    }
}
