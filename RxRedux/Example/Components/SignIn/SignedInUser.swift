import Foundation

struct SignedInUser: Equatable {
    static func ==(lhs: SignedInUser, rhs: SignedInUser) -> Bool {
        return lhs.id == rhs.id &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName
    }
    
    let id: Int
    let firstName: String
    let lastName: String
}
